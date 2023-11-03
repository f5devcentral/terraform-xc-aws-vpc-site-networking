output "vpc_id" {
  value       = var.vpc_id
  description = "The ID of the VPC."
}

output "vpc_cidr" {
  value       = data.aws_vpc.this.cidr_block
  description = "The CIDR block of the VPC."
}

output "outside_security_group_id" {
  value       = var.create_inside_security_group ? aws_security_group.outside[0].id : null
  description = "The ID of the outside security group."
}
  
output "inside_security_group_id" {
  value       = var.create_inside_security_group ? aws_security_group.inside[0].id : null
  description = "The ID of the inside security group."
}
