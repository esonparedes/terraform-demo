output "instance_id" {
  value       = aws_instance.web.*.id
  description = "AWS EC2 Information: Instance ID"
}

output "instance_public_ip" {
  value       = aws_instance.web.*.public_ip
  description = "AWS EC2 Information: Instance Private IP"
}

output "load_balancer_dns" {
  value       = aws_lb.lb.dns_name
  description = "AWS LB Information: Load Balancer DNS Name/URL"
}