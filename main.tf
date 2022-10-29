# main.tf

resource "tls_private_key" "${var.keyName}" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "${var.keyName}-keyfile" {
  filename = var.keyFile
  content = "${tls_private_key.${var.keyName}.private_key_openssh}"
}

# end of main.tf
