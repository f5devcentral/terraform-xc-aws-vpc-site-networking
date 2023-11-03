variable "vpc_id" {
  description = "The ID of an existing VPC."
  type        = string
  nullable    = false
}

variable "prefix" {
  description = "The prefix to use for all resource names."
  type        = string
  default     = ""
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