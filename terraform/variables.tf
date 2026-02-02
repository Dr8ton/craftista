variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "application_services" {
  description = "Defines all services to generate network rules and infrastructure."
  type = map(object({
    port         = number
    egress_rules = list(object({
      key  = string
      port = number
    }))
  }))

  default = {
    "catalogue" = {
      port         = 5000
      egress_rules = []
    },

    "voting" = {
      port = 8080
      egress_rules = [
        {
          key  = "catalogue"
          port = 5000
        }
      ]
    }
  }
}