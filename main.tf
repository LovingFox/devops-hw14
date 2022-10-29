# main.tf

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh_key-keyfile" {
  filename = var.keyFile
  content = tls_private_key.ssh_key.private_key_openssh
}

# end of main.tf
