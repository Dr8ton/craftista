# Craftista Project Roadmap

This document outlines the development roadmap for the Craftista project. The roadmap is divided into four phases, each with a specific goal and set of tasks.

## Phase 1: Containerization

**Goal:** Containerize each microservice using Docker.

**Definition of Done:**
* Each service has a working Dockerfile.
* A single `docker-compose.yml` file can be used to launch the entire application stack locally.
* The application, when running via `docker-compose`, is fully functional and behaves identically to running the services natively.

**Tasks:**

  **General**
  *   [ ] Create a `docker-compose.yml` file to orchestrate the services for local development.
  *   [x] Set up `act` cli tool for testing GH Actions locally. 

  **Catalogue Service**
  *   [x] Create a `Dockerfile`.

  **Frontend Service**
  *   [x] Create a `Dockerfile`.

  **Recommendation Service**
  *   [x] Create a `Dockerfile`.
  *   [ ] **Optimization:** Migrate from `alpine` to `scratch` or `distroless` base image to reduce image size and improve security.

  **Voting Service**
  *   [x] Create a `Dockerfile`.

## Phase 2: Continuous Integration & Continuous Deployment (CI/CD)

**Goal:** Implement a CI/CD pipeline with GitHub Actions.

**Definition of Done:**
* Each service has a dedicated GitHub Actions workflow.
* Workflows automatically trigger on events like pushes or pull requests to the `main` branch.
* The pipeline automatically builds, tests, and pushes Docker images to a container registry.

**Tasks:**

  **General**
  *   [ ] Configure workflows to build and push Docker images to a container registry on every push or pull request to the `main` branch.

  **Catalogue Service**
  *   [ ] Set up a GitHub Actions workflow to build and test the service.

  **Frontend Service**
  *   [ ] Set up a GitHub Actions workflow to build and test the service.

  **Recommendation Service**
  *   [ ] Set up a GitHub Actions workflow to build and test the service.

  **Voting Service**
  *   [ ] Set up a GitHub Actions workflow to build and test the service.

## Phase 3: Container Registry

**Goal:** Deploy the container images to Docker Hub.

**Definition of Done:**
* Each service has a corresponding repository on Docker Hub.
* The CI/CD pipeline is configured to authenticate with Docker Hub.
* The pipeline automatically pushes tagged images to Docker Hub upon successful builds.

**Tasks:**

  **General**
  *   [ ] Configure the CI/CD pipeline to authenticate with Docker Hub.

  **Catalogue Service**
  *   [ ] Create a Docker Hub repository and configure the pipeline to push the image.

  **Frontend Service**
  *   [ ] Create a Docker Hub repository and configure the pipeline to push the image.

  **Recommendation Service**
  *   [ ] Create a Docker Hub repository and configure the pipeline to push the image.

  **Voting Service**
  *   [ ] Create a Docker Hub repository and configure the pipeline to push the image.

## Phase 4: Cloud Deployment

**Goal:** Deploy the application to AWS.

**Definition of Done:**
* The entire application stack is deployed and running on a chosen AWS service (e.g., ECS, EKS, App Runner).
* The infrastructure is defined as code (IaC) using a tool like Terraform or CloudFormation.
* The CI/CD pipeline is configured to automatically deploy new versions of the application to the AWS environment.

**Tasks:**

  *   [ ] **Infrastructure:** Choose an appropriate AWS service for deploying containerized applications (e.g., Amazon ECS, Amazon EKS, or AWS App Runner).
  *   [ ] **Infrastructure:** Define the infrastructure as code (IaC) using a tool like Terraform or AWS CloudFormation.
  *   [ ] **Infrastructure:** Create the necessary AWS infrastructure (e.g., VPC, clusters, services, load balancers).
  *   [ ] **CI/CD:** Configure the CI/CD pipeline to deploy the application to the AWS environment.

## Phase 5: Observability

**Goal:** Instrument services to provide logs, metrics, and health checks.

**Definition of Done:**
* All services implement structured logging in a consistent format (e.g., JSON).
* Each service exposes a `/metrics` endpoint for Prometheus scraping.
* Each service has `/healthz` and `/readyz` endpoints for health checks.
* A local monitoring stack (e.g., Prometheus & Grafana) is configured in `docker-compose.yml` to collect and visualize metrics.

**Tasks:**

  **General**
  *   [ ] Define a project-wide strategy for structured logging (e.g., JSON format).
  *   [ ] Set up a local monitoring stack (e.g., Prometheus & Grafana) in `docker-compose.yml`.

  **Catalogue Service**
  *   [ ] Implement structured logging.
  *   [ ] Add a `/metrics` endpoint for Prometheus scraping.
  *   [ ] Add `/healthz` and `/readyz` health check endpoints.

  **Frontend Service**
  *   [ ] Implement structured logging.
  *   [ ] Add a `/metrics` endpoint for Prometheus scraping.
  *   [ ] Add `/healthz` and `/readyz` health check endpoints.

  **Recommendation Service**
  *   [ ] Implement structured logging.
  *   [ ] Add a `/metrics` endpoint for Prometheus scraping.
  *   [ ] Add `/healthz` and `/readyz` health check endpoints.

  **Voting Service**
  *   [ ] Implement structured logging.
  *   [ ] Add a `/metrics` endpoint for Prometheus scraping.
  *   [ ] Add `/healthz` and `/readyz` health check endpoints.

## Phase 6: Deploy to Kubernetes

**Goal:** Write kubernetes manifests to create Deployments, Services, PVCs, ConfigMaps, Statefulsets and more

**Definition of Done:**
* Each service has a Kubernetes Deployment and Service manifest.
* All necessary configurations are externalized into ConfigMaps.
* Persistent data is managed with PersistentVolumeClaims.
* The application can be fully deployed to a Kubernetes cluster using `kubectl apply`.

**Tasks:**
* [ ] Write Kubernetes manifests for each service.
* [ ] Create ConfigMaps for all service configurations.
* [ ] Define PersistentVolumeClaims for services that require persistent storage.

## Phase 7: Package with Helm

**Goal:** Write helm charts to templatize the kubernetes manifests and prepare to deploy in different environments

**Definition of Done:**
* A Helm chart is created for the entire application.
* The chart is templatized to allow for environment-specific configurations (e.g., development, staging, production).
* The application can be deployed to Kubernetes using `helm install`.

**Tasks:**
* [ ] Create a Helm chart for the Craftista application.
* [ ] Templatize the Kubernetes manifests with Helm.
* [ ] Create `values.yaml` files for different environments.

## Phase 8: Blue/Green and Canary Releases with ArgoCD/GitOps

**Goal:** Setup releases strategies with Argo Rollouts Combined with ArgoCD and integrate with CI Pipeline created in 3. to setup a complete CI/CD workflow.

**Definition of Done:**
* ArgoCD is set up to manage the application deployment in a GitOps fashion.
* Argo Rollouts is configured to enable blue/green or canary release strategies.
* The CI/CD pipeline is integrated with ArgoCD to trigger deployments.

**Tasks:**
* [ ] Install and configure ArgoCD.
* [ ] Install and configure Argo Rollouts.
* [ ] Create ArgoCD Application resources for the Craftista app.
* [ ] Integrate the CI/CD pipeline with ArgoCD.

## Phase 9: Setup Observability

**Goal:**  Setup monitoring with Prometheus and Grafana (Integrate this for automated CD with rollbacks using Argo), Setup log management with ELS/EFK Stack or Splunk.

**Definition of Done:**
* Prometheus and Grafana are deployed and configured to monitor the application.
* Automated rollbacks are configured in Argo Rollouts based on Prometheus metrics.
* A centralized logging solution (e.g., EFK stack) is deployed and configured to collect logs from all services.

**Tasks:**
* [ ] Deploy Prometheus and Grafana.
* [ ] Configure Prometheus to scrape metrics from the application.
* [ ] Create Grafana dashboards to visualize application metrics.
* [ ] Configure Argo Rollouts for automated rollbacks.
* [ ] Deploy and configure the EFK stack.

## Phase 10: Build a DevSecOps Pipeline

**Goal:** Create a DevSecOps Pipeline by adding SCA, SAST, Image Scanning, DAST, Compliance Scans, Kubernetes Scans etc. and more at each stage.

**Definition of Done:**
* The CI/CD pipeline includes stages for:
    * Static Application Security Testing (SAST)
    * Software Composition Analysis (SCA)
    * Docker image scanning
    * Dynamic Application Security Testing (DAST)
    * Kubernetes security scanning

**Tasks:**
* [ ] Integrate a SAST tool into the CI/CD pipeline.
* [ ] Integrate an SCA tool into the CI/CD pipeline.
* [ ] Integrate an image scanning tool into the CI/CD pipeline.
* [ ] Integrate a DAST tool into the CI/CD pipeline.
* [ ] Integrate a Kubernetes security scanning tool into the CI/CD pipeline.

## Phase 11: Design and Build Cloud Infra

**Goal:** Build Scalable, Hight Available, Resilience, Fault Tolerance Cloud Infra to host this app.

**Definition of Done:**
* The cloud infrastructure is designed to be scalable, highly available, and fault-tolerant.
* The infrastructure is deployed and configured on a cloud provider (e.g., AWS, GCP, Azure).

**Tasks:**
* [ ] Design a scalable, highly available, and fault-tolerant cloud architecture.
* [ ] Provision the cloud infrastructure.

## Phase 12: Write Terraform Templating

**Goal:** Automate the infra designed in project 8. Use Terragrunt on top for multi environment configurations.

**Definition of Done:**
* The entire cloud infrastructure is defined as code using Terraform.
* Terragrunt is used to manage Terraform configurations for multiple environments.

**Tasks:**
* [ ] Write Terraform code to provision the cloud infrastructure.
* [ ] Use Terragrunt to manage multiple environments.

## Phase 13: Python Scripts for Automation

**Goal:** Automate ad-hoc tasks using python scripts.

**Definition of Done:**
* Repetitive manual tasks are automated with Python scripts.

**Tasks:**
* [ ] Identify tasks that can be automated.
* [ ] Write Python scripts to automate those tasks.

## Reach Goals

### Deploy on EKS/AKS
**Goal:** Build EKS/AKS Cluster and deploy this app with helm packages you created earlier.

**Definition of Done:**
* An EKS or AKS cluster is provisioned.
* The Craftista application is deployed to the cluster using the Helm chart.

### Implement Service Mesh
**Goal:** Setup advanced observability, traffic management and shaping, mutual TLS, client retries  and more with Istio.

**Definition of Done:**
* Istio is installed and configured in the Kubernetes cluster.
* Advanced observability, traffic management, and security features are implemented.

### AIOps
**Goal:** On top of Observability, incorporate Machine Learning models, Falco and Argo Workflow for automated monitoring, incident response and mitigation.

**Definition of Done:**
* An AIOps platform is implemented for automated monitoring, incident response, and mitigation.

### SRE
**Goal:** Implement SLIs, SLOs, SLAs on top of the project 6 and setup Site Reliability Engineering practices.

**Definition of Done:**
* SLIs, SLOs, and SLAs are defined for the application.
* SRE best practices are implemented.

### Chaos Engineering
**Goal:** Use LitmusChaos to test resilience of your infra built on Cloud with Kubernetes and Istio.

**Definition of Done:**
* LitmusChaos is used to conduct chaos engineering experiments to test the resilience of the infrastructure.