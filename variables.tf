variable "customer_aws_profile" {
  type = string
}

variable "customer_aws_region_back" {
  type = string
}

variable "tags" {
  type = map(any)
  default = {
    "Iac" : true,
    "IacProvider" : "Terraform",
    "Environment" : "Test",
    "CreatedBy" : "haddan.rocha@gmail.com"    
  }
}

variable "path_tfstate" {
  type    = string
  default = ""
}
