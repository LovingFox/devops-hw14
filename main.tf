# main.tf

# create ssh key
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# save ssh key
resource "local_file" "ssh_key-keyfile" {
  filename = var.keyFile
  content = tls_private_key.ssh_key.private_key_openssh
}

# create ec2 key
resource "aws_key_pair" "aws_key" {
  key_name   = var.keyName
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# create ec2 security group
resource "aws_security_group" "aws_sg_ssh" {
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

# create ec2 instance
resource "aws_instance" "linux_instance" {
  ami             = var.ami
  instance_type   = var.instanceType 
  vpc_security_group_ids = [aws_security_group.aws_sg_ssh.id]
  key_name        = aws_key_pair.aws_key
  
  tags = {
    Name = var.instanceName
  }

  volume_tags = {
    Name = var.instanceName
  }
}


# end of main.tf
