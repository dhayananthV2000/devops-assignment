variable "ami" {
  type        = string
  description = "AMI ID to use for the instance"
}

variable "instance_type" {
  type        = string
  description = "Type of EC2 instance"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID to launch the instance in"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to associate"
}

variable "key_name" {
  type        = string
  description = "Name of the SSH key pair"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the instance"
  default     = {}
}

variable "name" {
  description = "Name prefix for naming resources"
  type        = string
}
