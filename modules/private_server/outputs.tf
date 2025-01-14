output "private_server_id" {
  description = "ID of the private server instance"
  value       = aws_instance.private_server.id
}

output "private_server_security_group_id" {
  description = "Security Group ID for the private server"
  value       = aws_security_group.private_server_sg.id
}
