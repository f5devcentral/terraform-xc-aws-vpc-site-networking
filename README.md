# AWS Networking module for F5 Distributed Cloud (XC) AWS VPC Site

This Terraform module provisions a VPC network in AWS that is required for XC Cloud AWS VPC Site. It creates a VPC, subnets, route tables, and security groups with whitelisted IP ranges.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](https://github.com/hashicorp/terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) | >= 5.0 |

## Usage


To use this module and create a VPC configured for XC Cloud AWS VPC Site on AWS Cloud, include the following code in your Terraform configuration:

```hcl
module "aws_vpc" {
  source  = "f5devcentral/aws-vpc-site-networking/xc"
  version = "0.0.5"

  name             = "aws-tf-demo-creds"
  az_names         = ["us-west-2a", "us-west-2b", "us-west-2c"]
  vpc_cidr         = "192.168.0.0/16"
  outside_subnets  = ["192.168.11.0/24", "192.168.12.0/24", "192.168.13.0/24"]
  inside_subnets   = ["192.168.21.0/24", "192.168.22.0/24", "192.168.23.0/24"]
  workload_subnets = ["192.168.31.0/24", "192.168.32.0/24", "192.168.33.0/24"]
}
```

## Contributing

Contributions to this module are welcome! Please see the contribution guidelines for more information.

## License

This module is licensed under the Apache 2.0 License.