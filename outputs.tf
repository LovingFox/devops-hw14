# outputs.tf

output "builder_dns_name" {
  value = aws_instance.linux_instance[*].public_dns
  description = "DNS name of the host"
}

output "bucket" {
  value = aws_s3_bucket.s3_bucket.bucket
  description = "bucket"
}

# end of outputs.tf
