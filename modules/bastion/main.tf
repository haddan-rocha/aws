# Security Group para o Bastion
resource "aws_security_group" "bastion_sg" {
  name        = "${var.instance_name}-sg"
  description = "Allow SSH access to Bastion from a specific IP"
  vpc_id      = var.vpc_id

  # Regra para permitir acesso SSH apenas do IP especificado
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip]
  }

    # Regra para permitir acesso HTTPS (porta 443) do IP especificado
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip]
  }

  # Regra para permitir acesso UDP (porta 17054) do IP especificado
  ingress {
    from_port   = 17054
    to_port     = 17054
    protocol    = "udp"
    cidr_blocks = [var.allowed_ip]
  }

  # Saída irrestrita
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "${var.instance_name}-sg"
  }, var.tags)
}

# Bastion EC2 Instance
resource "aws_instance" "bastion" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]

  tags = merge({
    Name = var.instance_name
  }, var.tags)
}
