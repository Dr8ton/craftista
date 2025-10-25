terraform {
  required_version = ">= 1.0.0" # Or a more specific version you prefer

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Or a more specific version you prefer, e.g., "5.x.x"
    }
  }
}
