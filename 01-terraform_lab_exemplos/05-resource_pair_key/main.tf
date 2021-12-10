# resource "aws_instance" "web2" {
#   subnet_id = "subnet-02d7741675f030d69"
#   ami = "ami-083654bd07b5da81d"
#   instance_type = "t2.micro"
#   key_name = "chave_key" # a chave que vc tem na maquina pessoal
#   associate_public_ip_address = true
#   vpc_security_group_ids = ["sg-083654bd07b5da81d"]
#   root_block_device {
#     encrypted = true
#     volume_size = 8
#   }
#   tags = {
#     Name = "ec2-clayton-tf"
#   }
# }
provider "aws" {
  region = "sa-east-1"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com" # outra opção "https://ifconfig.me"
}

# output ip {
#   value       = data.http.myip.body
#   description = "output de ip"
# }




resource "aws_security_group" "allow_ssh" {
  name        = "libera_ssh_grupo2_tf"
  description = "Allow SSH inbound traffic"
  vpc_id = "vpc-0a957401e8ad3cade"
  
  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["${chomp( data.http.myip.body )}/32"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups = null,
      self            = null
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids  = null,
      security_groups  = null,
      self             = null,
      description      = "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "libera_ssh_grupo2_tf"
  }
 
}


# output dns {
#   value       = aws_instance.web.public_dns
#   description = "dns para conexão ssh"
# }

resource "aws_instance" "web" {
  subnet_id = "subnet-00c59894f53620c61"
  ami = "ami-0e66f5495b4efdd0f"
  instance_type = "t2.micro"
  key_name = "cert-turma3-cleber-dev" # a chave que vc tem na maquina pessoal
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]   #["sg-0c40cb54147ae844b"]
  root_block_device {
    encrypted = true
    volume_size = 8
  }
  tags = {
  
    Name = "ec2_cleber_keys_tf"
  }
  /*depends_on = [
    aws_security_group.allow_ssh
  ]*/
}

/*
output "public_ip" {
    value = aws_instance.web.public_ip
}
output "public_dns" {
    value = aws_instance.web.public_dns
}

output "ssh_dns" {
    value = "ssh -i cert-turma3-cleber-dev.pem ubuntu@${aws_instance.web.public_dns}"
}*/

output "ssh_ip" {
    value = [
           <<EOF
           ssh -i ~/cert-turma3-cleber-dev.pem ubuntu@${aws_instance.web.public_ip}
           EOF
    ]
}