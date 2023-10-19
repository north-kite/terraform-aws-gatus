output "security_group_id" {
  description = "Security group assigned to Gatus container. Add rules here to grant Gatus access to endpoint to monitor."
  value       = aws_security_group.gatus.id
}
