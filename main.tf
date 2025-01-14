provider "aws" {
  region  = var.customer_aws_region_back
  profile = var.customer_aws_profile
  default_tags {
    tags = var.tags
  }
}

module "network" {
  source = "./modules/network"

  vpc_name          = "haddan-test"
  cidr_block        = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.2.0/24"]
  tags = var.tags
}

output "igw_id" {
  value = module.network.internet_gateway_id
}

output "nat_gw_id" {
  value = module.network.nat_gateway_id
}
