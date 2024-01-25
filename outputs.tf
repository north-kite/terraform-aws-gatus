output "security_group_id" {
  description = "Security group assigned to Gatus container. Add rules here to grant Gatus access to endpoint to monitor."
  value       = aws_security_group.gatus.id
}

output "alb_dns_name" {
  description = "Application loadbalancer DNS name. This DNS name can be used directly or in a custom DNS record."
  value       = var.alb == null ? aws_lb.alb[0].dns_name : null
}
