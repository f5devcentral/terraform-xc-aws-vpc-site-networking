output "vpc_id" {
  value       = local.vpc_id
  description = "The ID of the VPC."
}

output "vpc_name" {
  value       = local.vpc_name
  description = "The name of the VPC."
}

output "vpc_cidr" {
  value       = var.vpc_cidr
  description = "The CIDR block of the VPC."
}

output "outside_subnet_ids" {
  value       = aws_subnet.outside.*.id
  description = "The IDs of the outside subnets."
}

output "inside_subnet_ids" {
  value       = aws_subnet.inside.*.id
  description = "The IDs of the inside subnets."
}

output "workload_subnet_ids" {
  value       = aws_subnet.workload.*.id
  description = "The IDs of the workload subnets."
}

output "local_subnet_ids" {
  value       = aws_subnet.local.*.id
  description = "The IDs of the local subnets."
}

output "outside_route_table_id" {
  value       = var.create_outside_route_table ? aws_route_table.outside[0].id : null
  description = "The ID of the outside route table."
}

output "internet_gateway_id" {
  value       = var.create_internet_gateway ? aws_internet_gateway.this[0].id : null
  description = "The ID of the internet gateway."
}

output "outside_security_group_id" {
  value       = module.aws_vpc_sg.outside_security_group_id
  description = "The ID of the outside security group."
}
  
output "inside_security_group_id" {
  value       = module.aws_vpc_sg.inside_security_group_id
  description = "The ID of the inside security group."
}

output "default_security_group_id" {
  value       = try(aws_default_security_group.default[0].id, null)
  description = "The ID of the default security group."
}

output "az_names" {
  value       = local.az_names
  description = "Availability zones."
}