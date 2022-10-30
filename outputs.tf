# outputs.tf

output "bucket" {
  value = aws_s3_bucket.s3_bucket.bucket
  description = "bucket"
}

output "builder_dns_name" {
  value = aws_instance.builder_instance.public_dns
  description = "DNS name of the Builder"
}

output "webserver_dns_name" {
  value = aws_instance.webserver_instance.public_dns
  description = "DNS name of the Webserver"
}

# end of outputs.tf
