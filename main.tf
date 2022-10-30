# main.tf

######
# bucket
resource "aws_s3_bucket" "s3_bucket" {
    bucket_prefix = "${var.bucketName}-"
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
# cloud builder init template
data "template_file" "builder_script" {
  template = file(var.dataFileBuilder)
  vars = {
      repo    = "${var.gitRepo}"
      dir     = "${var.workingDir}"
      file    = "${var.bucketName}"
      bucket  = "${aws_s3_bucket.s3_bucket.bucket}"
  }
}

# cloud builder init config
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
# create ec2 builder security group
resource "aws_security_group" "sg_builder" {
  name = var.securityGroupBuilder
  description = "[Terraform] Builder ACL"

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
  name_prefix        = "${var.projectName}-"
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
  name_prefix        = "${var.projectName}-"
  role = aws_iam_role.iam_role.name
}

# iam role policy attachments
resource "aws_iam_role_policy_attachment" "iam_role_pol_att" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  ])
  role       = aws_iam_role.iam_role.name
  policy_arn = each.value
}
# iam end
######

# create ec2 builder instance
resource "aws_instance" "builder_instance" {
  ami                        = var.ami
  instance_type              = var.instanceType 
  key_name                   = aws_key_pair.aws_key.key_name
  vpc_security_group_ids     = [ aws_security_group.sg_builder.id ]
  user_data_base64           = "${data.template_cloudinit_config.builder_config.rendered}"
  iam_instance_profile       = aws_iam_instance_profile.iam_inst_prof.name
  
  tags = {
    Name = var.instanceNameBuilder
  }

  volume_tags = {
    Name = var.instanceNameBuilder
  }
}

# end of main.tf
