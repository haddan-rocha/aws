variable "instance_name" {
  description = "Name of the Bastion instance"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID of the public subnet where the Bastion will be deployed"
  type        = string
}

variable "allowed_ip" {
  description = "CIDR block for SSH access (e.g., your local machine IP)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the Linux server"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the Bastion server"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
