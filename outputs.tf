# outputs.tf

output "builder_dns_name" {
  value = aws_instance.linux_instance[*].public_dns
  description = "DNS name of the host"
}

# end of outputs.tf
