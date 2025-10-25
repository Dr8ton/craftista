# Craftista AWS Deployment Plan

This document outlines the plan for deploying the Craftista application to AWS using EC2 instances.

## Phase 1: Network Foundation

This phase focuses on creating a secure and isolated network environment for the application services.

### 1. Virtual Private Cloud (VPC)
- **Action:** Create a new, custom VPC instead of using the default VPC. This provides full control over the network environment.
- **CIDR Block:** `10.0.0.0/16`
- **Components:**
    - **VPC:** The main container for all network resources.
    - **Subnets:** We will create two subnets for different security levels.
    - **Gateways:** We will create an Internet Gateway and a NAT Gateway to manage traffic flow.
    - **Route Tables:** We will create custom route tables to direct traffic within the VPC.

### 2. Subnets
We will create two subnets within the VPC:
- **Public Subnet:**
    - **Purpose:** To host publicly accessible resources, starting with the `frontend` service.
    - **CIDR Block:** `10.0.1.0/24`
- **Private Subnet:**
    - **Purpose:** To host backend services (`catalogue`, `recommendation`, `voting`) that should not be directly accessible from the internet.
    - **CIDR Block:** `10.0.2.0/24`

### 3. Gateways & Connectivity

- **Internet Gateway (IGW):**
    - **Action:** Create an IGW and attach it to the VPC.
    - **Purpose:** To allow communication between resources in the public subnet and the internet.

- **NAT Gateway:**
    - **Action:** Create a NAT Gateway.
    - **Placement:** It must be placed within the **public subnet**.
    - **IP Address:** It will be assigned an Elastic IP (a static public IP).
    - **Purpose:** To allow instances in the **private subnet** to initiate outbound traffic to the internet (e.g., for software updates) without allowing inbound connections from the internet.

### 4. Route Tables

- **Main Route Table:** Every VPC has a main route table by default. We will leave this as is, ensuring it does not have a route to the IGW, making it private by default.
- **Public Route Table:**
    - **Action:** Create a new, custom route table.
    - **Association:** Associate it with the **public subnet**.
    - **Rules:**
        - `10.0.0.0/16` -> `local` (Default rule for internal VPC communication)
        - `0.0.0.0/0` -> `Internet Gateway` (Directs all other traffic to the internet)
- **Private Route Table:**
    - **Action:** Create another new, custom route table.
    - **Association:** Associate it with the **private subnet**.
    - **Rules:**
        - `10.0.0.0/16` -> `local` (Default rule for internal VPC communication)
        - `0.0.0.0/0` -> `NAT Gateway` (Directs all internet-bound traffic from private instances through the NAT Gateway)

---

## Phase 2: Compute & Security

This phase covers the creation and configuration of the EC2 instances that will run the containerized services.

### 1. Amazon Machine Image (AMI)
- **Choice:** Standard Ubuntu Server 22.04 LTS AMI.
- **Reasoning:** Provides a clean, well-supported base OS. We will install dependencies ourselves for a better learning experience.

### 2. Instance Type
- **Choice:** `t2.micro`
- **Reasoning:** This instance type is eligible for the AWS Free Tier and provides sufficient "burstable" performance for this small project, keeping costs to a minimum.

### 3. Instance Configuration (User Data)
- **Action:** On the first boot, each EC2 instance will run the following `user-data` script to prepare the environment.
- **Purpose:** To update the OS, install the Docker engine, and add the `ubuntu` user to the `docker` group.

```bash
#!/bin/bash
apt-get update -y
apt-get install -y docker.io
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu
```

### 4. Security Groups (Instance Firewalls)
Two security groups will be created: one for the frontend and one for the shared backend services.

- **`sg-frontend`:**
  - **Purpose:** To control traffic for the `frontend` EC2 instance.
  - **Inbound Rules:**
    - **Type:** HTTP
    - **Protocol:** TCP
    - **Port:** 80
    - **Source:** `0.0.0.0/0` (Allows web traffic from anywhere on the internet)
  - **Default Outbound:** Allow all (This is the default and can be left as is).

- **`sg-backend`:**
  - **Purpose:** To control traffic for the `catalogue`, `recommendation`, and `voting` EC2 instances.
  - **Inbound Rules:**
    - **Rule 1 (Catalogue):**
      - **Type:** Custom TCP
      - **Protocol:** TCP
      - **Port:** 5001
      - **Source:** `sg-frontend` (Allows traffic only from the frontend instance)
    - **Rule 2 (Recommendation):**
      - **Type:** Custom TCP
      - **Protocol:** TCP
      - **Port:** 8080
      - **Source:** `sg-frontend` (Allows traffic only from the frontend instance)
    - **Rule 3 (Voting):**
      - **Type:** Custom TCP
      - **Protocol:** TCP
      - **Port:** 8081
      - **Source:** `sg-frontend` (Allows traffic only from the frontend instance)
  - **Default Outbound:** Allow all (This is the default and allows the instances to talk to each other and, via the NAT Gateway, the internet).

---

## Phase 3: Application Deployment

This phase describes how the container images will be deployed and run on the EC2 instances, automated via Terraform.

### 1. Deployment Process
The process of running the containers will be automated within the `user-data` of each EC2 instance, managed by Terraform.

- **Image Source:** Container images will be pulled from Docker Hub. The `user-data` script will include `docker login` (using credentials from a secure source like AWS Secrets Manager) followed by `docker pull <image_name>`.
- **Container Execution:** After pulling the image, the script will use `docker run` to start the container. The `docker run` command will be configured to restart the container automatically if it stops (`--restart=always`).

### 2. Configuration and Service Discovery
The critical challenge of letting the `frontend` service discover the backend services will be solved by Terraform.

- **Mechanism:** Environment Variables. The application code should be written to read service URLs from environment variables (e.g., `CATALOGUE_URL`).
- **Terraform's Role:**
    1. Terraform will create the backend EC2 instances (`catalogue`, `recommendation`, `voting`) first.
    2. It will then access the `private_ip` attribute of these newly created instances.
    3. When defining the `frontend` EC2 instance, Terraform will use these IP addresses to construct the service URLs and inject them into the `user-data` script.
    4. This script will then start the `frontend` container using `docker run`, passing the service URLs as environment variables (`-e`).
- **Dependency Management:** This process relies on Terraform's **implicit dependency** feature. Because the frontend resource references attributes from the backend resources, Terraform automatically creates them in the correct order. An explicit `depends_on` is not required.

### Example Conceptual `user-data` for Frontend

```bash
#!/bin/bash
# ... (docker installation script) ...

# Login to Docker Hub (credentials should be securely passed)
docker login --username <user> --password <pass>

# Pull and Run the frontend container
# The IP addresses are filled in by Terraform at deploy time
docker run -d --restart=always -p 80:3000 \
  -e CATALOGUE_URL="http://${catalogue_ip}:5001" \
  -e RECOMMENDATION_URL="http://${recommendation_ip}:8080" \
  -e VOTING_URL="http://${voting_ip}:8081" \
  your/frontend-image
```

---

## Phase 4: CI/CD for Infrastructure (GitOps)

This phase outlines a future goal for automating the deployment of the infrastructure itself using GitHub Actions, following a GitOps model.

### 1. On Pull Request (Review)
- **Trigger:** A pull request is opened with changes to any `.tf` Terraform files.
- **Workflow:**
    1. The workflow checks out the code.
    2. It securely authenticates to AWS using OIDC.
    3. It runs `terraform init`, `validate`, and `plan`.
    4. The output of the `terraform plan` is automatically posted as a comment on the pull request.
- **Goal:** To enable peer review of all infrastructure changes before they are applied.

### 2. On Merge to `main` (Apply)
- **Trigger:** The pull request with infrastructure changes is merged into the `main` branch.
- **Workflow:**
    1. The workflow runs the same initial steps (`init`, `validate`).
    2. It then executes `terraform apply -auto-approve` to apply the planned changes to the AWS account.
- **Goal:** To automate the deployment of infrastructure, creating a reliable and auditable trail of all changes based on the Git history).

---

**Progress Note:**
As of October 21, 2025, Phase 1: Network Foundation has been fully defined in the Terraform configuration files (`terraform/`). The next step is to run `terraform init` and `terraform plan` from within the `terraform/` directory to validate the configuration.
