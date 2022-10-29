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

# cloud init template
data "template_file" "builder_script" {
  template = file(var.dataFile)
  vars = {
      repo = "${var.gitRepo}"
      dir = "${var.workingDir}"
  }
}

# cloud init config
data "template_cloudinit_config" "builder_config" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = "${data.template_file.builder_script.rendered}"
  }
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

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# create ec2 instance
resource "aws_instance" "linux_instance" {
  ami                        = var.ami
  instance_type              = var.instanceType 
  key_name                   = aws_key_pair.aws_key.key_name
  vpc_security_group_ids     = [ aws_security_group.aws_sg_ssh.id ]
  # user_data                  = data.template_file.builder_data.rendered
  user_data_base64           = "${data.template_cloudinit_config.builder_config.rendered}"
  count                      = 1
  
  tags = {
    Name = var.instanceName
  }

  volume_tags = {
    Name = var.instanceName
  }

  # connection {
  #   type        = "ssh"
  #   user        = "ubuntu"
  #   private_key = file(var.keyFile)
  #   host        = self.public_ip
  # }
  # provisioner "file" {
  #   source      = "${var.setupFile}"
  #   destination = "${var.setupFile}"
  # }
}

# end of main.tf
