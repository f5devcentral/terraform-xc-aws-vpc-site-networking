
variable "name" {
  description = "The name of the VPC."
  type        = string
  default     = null
}

variable "existing_vpc_id" {
  description = "The ID of an existing VPC to use instead of creating a new one."
  type        = string
  default     = null
}

variable "create_outside_route_table" {
  description = "Whether to create an outside route table for the outside subnets."
  type        = bool
  default     = true
}

variable "create_internet_gateway" {
  description = "Whether to create an internet gateway."
  type        = bool
  default     = true
}

variable "create_outside_security_group" {
  description = "Whether to create an outside security group."
  type        = bool
  default     = true
}

variable "create_inside_security_group" {
  description = "Whether to create an inside security group."
  type        = bool
  default     = true
}

variable "create_udp_security_group_rules" {
  description = "Whether to create UDP security group rules."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "az_names" {
  description = "Availability Zone Names for Subnets."
  type        = list(string)
  default     = []
}

variable "local_subnets" {
  description = "Local Subnet CIDR Blocks."
  type        = list(string)
  default     = []
}

variable "inside_subnets" {
  description = "Inside Subnet CIDR Blocks."
  type        = list(string)
  default     = []
}

variable "outside_subnets" {
  description = "Outside Subnet CIDR Blocks."
  type        = list(string)
  default     = []
}

variable "workload_subnets" {
  description = "Workload Subnet CIDR Blocks."
  type        = list(string)
  default     = []
}

variable "vpc_cidr" {
  description = "The Primary IPv4 block cannot be modified. All subnets prefixes in this VPC must be part of this CIDR block."
  type        = string
  default     = null
}

variable "vpc_instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC."
  type        = string
  default     = "default"
}

variable "vpc_enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC."
  type        = bool
  default     = true
}

variable "vpc_enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC."
  type        = bool
  default     = true
}

variable "vpc_enable_network_address_usage_metrics" {
  description = "Determines whether network address usage metrics are enabled for the VPC."
  type        = bool
  default     = false
}
