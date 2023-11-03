# AWS VPC for F5 XC Cloud Ingress/Egress GW AWS VPC Site

The following example will create an AWS VPC with 3 AZs, 3 subnets per AZ, and a security group. The security groups will be configured with whitelisted IP ranges for the XC Cloud Ingress/Egress GW AWS VPC Site.

```hcl
module "aws_vpc" {
  source = "../.."

  name             = "aws-tf-demo-creds"
  az_names         = ["us-west-2a", "us-west-2b", "us-west-2c"]
  vpc_cidr         = "192.168.0.0/16"
  outside_subnets  = ["192.168.11.0/24", "192.168.12.0/24", "192.168.13.0/24"]
  inside_subnets   = ["192.168.21.0/24", "192.168.22.0/24", "192.168.23.0/24"]
  workload_subnets = ["192.168.31.0/24", "192.168.32.0/24", "192.168.33.0/24"]
}
```