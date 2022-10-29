# main.tf

# create ssh key
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# save ssh key
resource "local_file" "ssh_key-keyfile" {
  filename = var.keyFile
  file_permission = "0400"
  content = tls_private_key.ssh_key.private_key_openssh
}

# data "template_file" "builder_data" {
#   template = file(var.dataFile)
#   vars = {
#       repo = "${var.gitRepo}"
#       dir = "${var.workingDir}"
#   }
# }

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
  ami                        = var.ami
  instance_type              = var.instanceType 
  key_name                   = var.keyName
  vpc_security_group_ids     = [ aws_security_group.aws_sg_ssh.id ]
  # user_data                  = data.template_file.builder_data.rendered
  user_data = <<EOF
  sudo apt-get update
  sudo apt-get install -y default-jre maven git
  git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git repo
  cd repo
  mvn clean package
  EOF
  
  tags = {
    Name = var.instanceName
  }

  volume_tags = {
    Name = var.instanceName
  }
}

# end of main.tf
