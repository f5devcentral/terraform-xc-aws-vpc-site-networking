provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-west-2"
}

module "aws_vpc" {
  source = "../.."

  name             = "aws-tf-demo-creds"
  az_names         = ["us-west-2a", "us-west-2b", "us-west-2c"]
  vpc_cidr         = "192.168.0.0/16"
  outside_subnets  = ["192.168.11.0/24", "192.168.12.0/24", "192.168.13.0/24"]
  inside_subnets   = ["192.168.21.0/24", "192.168.22.0/24", "192.168.23.0/24"]
  workload_subnets = ["192.168.31.0/24", "192.168.32.0/24", "192.168.33.0/24"]
}
