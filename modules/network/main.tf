# Criar o Internet Gateway (IGW)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = merge({
    Name = "${var.vpc_name}-igw"
  }, var.tags)
}

# Criar a Tabela de Rotas Pública
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge({
    Name = "${var.vpc_name}-public-rt"
  }, var.tags)
}

# Associação da Sub-rede Pública com a Tabela de Rotas Pública
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Criar a rota para o Internet Gateway na tabela de rotas pública
resource "aws_route" "public_to_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Criar um Elastic IP para o NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge({
    Name = "${var.vpc_name}-nat-eip"
  }, var.tags)
}

# Criar o NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public[keys(aws_subnet.public)[0]].id
  depends_on    = [aws_internet_gateway.igw]

  tags = merge({
    Name = "${var.vpc_name}-nat"
  }, var.tags)
}

# Criar a Tabela de Rotas Privada
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge({
    Name = "${var.vpc_name}-private-rt"
  }, var.tags)
}

# Associação da Sub-rede Privada com a Tabela de Rotas Privada
resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

# Criar a rota para o NAT Gateway na tabela de rotas privada
resource "aws_route" "private_to_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge({
    Name = var.vpc_name
  }, var.tags)
}

resource "aws_subnet" "public" {
  for_each = toset(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  map_public_ip_on_launch = true
  availability_zone = "${var.region}a"

  tags = merge({
    Name = "${var.vpc_name}-public-${each.key}"
  }, var.tags)
}

resource "aws_subnet" "private" {
  for_each = toset(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = "${var.region}a"

  tags = merge({
    Name = "${var.vpc_name}-private-${each.key}"
  }, var.tags)
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private : subnet.id]
}