# outputs.tf

output "instance_public_dns_name" {
  value = aws_instance.linux_instance[*].public_dns
  description = "DNS name of the host"
}

output "bucket_domain_name" {
  value = aws_s3_bucket.s3_bucket.bucket_domain_name
  description = "bucket_domain_name"
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.s3_bucket.bucket_domain_name
  description = "bucket_regional_domain_name"
}

output "bucket" {
  value = aws_s3_bucket.s3_bucket.bucket_domain_name
  description = "bucket"
}

# end of outputs.tf
