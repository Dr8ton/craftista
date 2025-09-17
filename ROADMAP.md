# Craftista Project Roadmap

This document outlines the development roadmap for the Craftista project. The roadmap is divided into four phases, each with a specific goal and set of tasks.

## Phase 1: Containerization

**Goal:** Containerize each microservice using Docker.

**Tasks:**

*   [x] Create a `Dockerfile` for the `frontend` service.
*   [x] Create a `Dockerfile` for the `catalogue` service.
*   [x] Create a `Dockerfile` for the `recommendation` service.
*   [x] Create a `Dockerfile` for the `voting` service.
*   [ ] Create a `docker-compose.yml` file to orchestrate the services for local development.

## Phase 2: Continuous Integration & Continuous Deployment (CI/CD)

**Goal:** Implement a CI/CD pipeline with GitHub Actions.

**Tasks:**

*   [ ] Set up GitHub Actions workflows for each service.
*   [ ] Workflows should build and test each service automatically on every push or pull request to the `main` branch.
*   [ ] Workflows should build and push Docker images to a container registry.

## Phase 3: Container Registry

**Goal:** Deploy the container images to Docker Hub.

**Tasks:**

*   [ ] Create a Docker Hub repository for each service's container image.
*   [ ] Configure the CI/CD pipeline to authenticate with Docker Hub and push the images.

## Phase 4: Cloud Deployment

**Goal:** Deploy the application to AWS.

**Tasks:**

*   [ ] Choose an appropriate AWS service for deploying containerized applications (e.g., Amazon ECS, Amazon EKS, or AWS App Runner).
*   [ ] Define the infrastructure as code (IaC) using a tool like Terraform or AWS CloudFormation.
*   [ ] Create the necessary AWS infrastructure (e.g., VPC, clusters, services, load balancers).
*   [ ] Configure the CI/CD pipeline to deploy the application to the AWS environment.
