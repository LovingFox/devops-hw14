# outputs.tf

output "instance_public_dns_name" {
  value = aws_instance.linux_instance.public_dns
}

# end of outputs.tf