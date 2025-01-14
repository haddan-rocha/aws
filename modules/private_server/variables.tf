variable "instance_name" {
  description = "Name of the private server instance"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID of the private subnet"
  type        = string
}

variable "bastion_sg_id" {
  description = "ID of the Bastion's Security Group"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the private server"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the private server"
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
