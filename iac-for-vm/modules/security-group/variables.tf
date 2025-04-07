variable "name" {
  type        = string
  description = "Name of the security group"
}

variable "description" {
  type        = string
  description = "Description of the security group"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to attach the security group to"
}

variable "allowed_ssh_cidrs" {
  type        = list(string)
  description = "List of CIDRs allowed to SSH"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
  default     = {}
}
