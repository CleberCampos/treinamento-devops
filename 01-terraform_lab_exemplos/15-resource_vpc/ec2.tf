resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  subnet_id                   = aws_subnet.my_subnet_a.id
  #count                       = var.quantidade
  key_name                    = aws_key_pair.chave_key_cleber.key_name
  associate_public_ip_address = true
  root_block_device {
    encrypted   = true
    volume_size = 8
  }
  tags = {
    Name = "ec2-turma3-cleber-terraform-a"
  }
}