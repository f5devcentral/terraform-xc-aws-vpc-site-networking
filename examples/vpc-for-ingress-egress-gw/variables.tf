variable "aws_access_key" {
  type        = string
  default     = null
  description = "AWS access key"
}

variable "aws_secret_key" {
  type        = string
  sensitive   = true
  description = "AWS secret key"
  default     = null
}