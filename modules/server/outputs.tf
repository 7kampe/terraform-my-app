
output "public_dns" {
  value = aws_instance.web.public_dns
}
output "size" {
  description = "Size of server built with Server Module"
  value       = aws_instance.web.instance_type
}


output "public_ip" {
  description = "IP Address of server built with Server Module"
  value       = aws_instance.web.public_ip
}