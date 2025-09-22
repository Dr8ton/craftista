# Craftista Project Roadmap

This document outlines the development roadmap for the Craftista project. The roadmap is divided into four phases, each with a specific goal and set of tasks.

## Phase 1: Containerization

**Goal:** Containerize each microservice using Docker.

**Tasks:**

  **General**
  *   [ ] Create a `docker-compose.yml` file to orchestrate the services for local development.
  *   [ ] Set up `act` cli tool for testing GH Actions locally. 

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

**Tasks:**

  *   [ ] **Infrastructure:** Choose an appropriate AWS service for deploying containerized applications (e.g., Amazon ECS, Amazon EKS, or AWS App Runner).
  *   [ ] **Infrastructure:** Define the infrastructure as code (IaC) using a tool like Terraform or AWS CloudFormation.
  *   [ ] **Infrastructure:** Create the necessary AWS infrastructure (e.g., VPC, clusters, services, load balancers).
  *   [ ] **CI/CD:** Configure the CI/CD pipeline to deploy the application to the AWS environment.
  *   [ ] **Deployment Strategy:** Implement a promotion-based deployment workflow (e.g., Dev -> QA -> Prod). This includes setting up separate environments and promoting immutable container images between them.

## Phase 5: Observability

**Goal:** Instrument services to provide logs, metrics, and health checks.

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
