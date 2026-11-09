terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.40.0" }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = "dev"
      ManagedBy   = "terraform"
      Project     = "basecamp-aws"
    }
  }
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "bucket_name" {
  type        = string
  description = "Globally unique name for the central log bucket"
}

module "vpc" {
  source             = "../../modules/vpc"
  name               = "dev"
  single_nat_gateway = true # dev: cheaper single NAT
  tags               = { Scope = "landing-zone" }
}

module "logs_key" {
  source      = "../../modules/kms"
  alias       = "dev-logs"
  description = "Encryption for the central log bucket"
}

module "central_logs" {
  source      = "../../modules/s3-logging"
  bucket_name = var.bucket_name
  kms_key_arn = module.logs_key.key_arn
  tags        = { Scope = "landing-zone" }
}

module "iam" {
  source           = "../../modules/iam-baseline"
  deploy_role_arns = []
}

output "vpc_id" { value = module.vpc.vpc_id }
output "private_subnet_ids" { value = module.vpc.private_subnet_ids }
output "log_bucket_name" { value = module.central_logs.bucket_name }
