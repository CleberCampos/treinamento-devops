resource "aws_key_pair" "chave_key_cleber" {
  key_name   = "chave_key_cleber_tf"
  public_key = var.ssh_pub_key
  }