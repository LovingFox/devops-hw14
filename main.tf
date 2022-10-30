# main.tf

######
# bucket
resource "aws_s3_bucket" "s3_bucket" {
    bucket = "${var.bucketName}"
    tags = {
        Name = "${var.bucketName}"
    }
}

# acl for bucket
resource "aws_s3_bucket_acl" "s3_buck_acl" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
}
######

######
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

# create ec2 key
resource "aws_key_pair" "aws_key" {
  key_name   = var.keyName
  public_key = tls_private_key.ssh_key.public_key_openssh
}
######

######
# cloud init template
data "template_file" "builder_script" {
  template = file(var.dataFile)
  vars = {
      repo    = "${var.gitRepo}"
      dir     = "${var.workingDir}"
      bucket  = "${var.bucketName}"
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
######

######
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
######

######
# iam role
resource "aws_iam_role" "iam_role" {
  name_prefix        = "${var.instanceName}-"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# iam instance profile
resource "aws_iam_instance_profile" "iam_inst_prof" {
  name_prefix        = "${var.instanceName}-"
  role = aws_iam_role.iam_role.name
}

# iam role policy attachments
resource "aws_iam_role_policy_attachment" "iam_role_pol_att" {
  for_each = toset([
    # "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  ])
  role       = aws_iam_role.iam_role.name
  policy_arn = each.value
}
# iam end
######

# create ec2 instance
resource "aws_instance" "linux_instance" {
  ami                        = var.ami
  instance_type              = var.instanceType 
  key_name                   = aws_key_pair.aws_key.key_name
  vpc_security_group_ids     = [ aws_security_group.aws_sg_ssh.id ]
  user_data_base64           = "${data.template_cloudinit_config.builder_config.rendered}"
  iam_instance_profile       = aws_iam_instance_profile.iam_inst_prof.name
  count                      = 1
  
  tags = {
    Name = var.instanceName
  }

  volume_tags = {
    Name = var.instanceName
  }
}

# end of main.tf
