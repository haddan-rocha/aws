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

module "bastion" {
  source        = "./modules/bastion"
  instance_name = "bastion-host"
  vpc_id        = module.network.vpc_id
  subnet_id     = module.network.public_subnet_ids[0] # Use a primeira sub-rede pública
  allowed_ip    = "189.37.72.118/32" # IP da sua máquina local
  ami_id        = "ami-0e2c8caa4b6378d8c"     # Substitua pela AMI do Linux desejada
  instance_type = "t3.micro"
  key_name      = "bastion"       # Substitua pelo nome do par de chaves
  tags = var.tags
}

module "private_server" {
  source        = "./modules/private_server"
  instance_name = "private-server"
  vpc_id        = module.network.vpc_id
  subnet_id     = module.network.private_subnet_ids[0] # Use a primeira sub-rede privada
  bastion_sg_id = module.bastion.bastion_security_group_id
  ami_id        = "ami-0e2c8caa4b6378d8c" # Substitua pela AMI desejada
  instance_type = "t3.micro"
  key_name      = "private-server"
  tags = var.tags
  
}