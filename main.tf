# main.tf

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh_key-keyfile" {
  filename = var.keyFile
  content = tls_private_key.ssh_key.private_key_openssh
}

resource "aws_security_group" "sg_ssh" {
  name = var.securityGroup
  description = "[Terraform] Allow SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# end of main.tf
