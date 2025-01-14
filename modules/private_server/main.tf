# Security Group para o Servidor na Rede Privada
resource "aws_security_group" "private_server_sg" {
  name        = "${var.instance_name}-sg"
  description = "Allow ping from Bastion server"
  vpc_id      = var.vpc_id

  # Permitir ICMP (Ping) apenas do Security Group do Bastion
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    security_groups = [var.bastion_sg_id]
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

# Servidor na Rede Privada
resource "aws_instance" "private_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  vpc_security_group_ids = [
    aws_security_group.private_server_sg.id
  ]

  tags = merge({
    Name = var.instance_name
  }, var.tags)
}
