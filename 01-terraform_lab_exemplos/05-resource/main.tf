# provider "aws" {
#   region = "us-east-1"
# }

# resource "aws_instance" "web" {
#   ami           = "ami-09e67e426f25ce0d7"
#   instance_type = "t2.micro"
#   subnet_id              = "subnet-eddcdzz4"
#   # availability_zones = ["us-east-1"] # configurando zona para criar maquinas
#   tags = {
#     Name = "Minha Maquina Simples EC2"
#   }
#   volume_id = aws_ebs_volume.itau_volume_encrypted.id
# }


# resource "aws_ebs_volume" "itau_volume_encrypted" {
#   size      = 8
#   encrypted = true
#   tags      = {
#     Name = "Volume itaú"
#   }
# }



##### Caso Itaú #####
# aws configure # maquina pessoal
# nas do itaú colocar as variáveis de ambiente no bashrc
# https://docs.aws.amazon.com/sdkref/latest/guide/environment-variables.html
# configurar via environment variable
# export AWS_ACCESS_KEY_ID=""
# export AWS_SECRET_ACCESS_KEY=""
# export AWS_DEFAULT_REGION=""

# provider "aws" {
#   region = "us-east-1"
# }

# resource "aws_instance" "web" {
#   ami = "ami-09e67e426f25ce0d7"
#   instance_type = "t3.micro"
#   subnet_id = "subnet-05880ea9006199004"
  
#   tags = {
#     Name = "MinhaPrimeiraMaquina-Carol  "
#   }
# }

# resource "aws_ebs_volume" "itau_volume_encrypted" {
#   size      = 8
#   encrypted = true
#   availability_zone = "us-east-1a"
#   tags      = {
#     Name = "Volume itaú"
#   }
# }

# resource "aws_volume_attachment" "ebs_att" {
#   device_name = "/dev/sdh"
#   volume_id   = aws_ebs_volume.itau_volume_encrypted.id
#   instance_id = aws_instance.web.id
# }

# Gamaacademythree-sbx - # passago a chave pelo pessoal de segurança itaú
# export AWS_ACCESS_KEY_ID="3232323232"
# export AWS_SECRET_ACCESS_KEY="34433444sssdd3+ssa/dd434343"

# //////

# ///////// do fernando zerati //////
/*
provider "aws" {
  region = "sa-east-1"
}

variable "maquinas" {
  default     = {
    ec2-dani-web1 = { 
      subnet = "subnet-0b4c2d3405900ca30", 
      size = "t2.micro"
    },
    ec2-dani-web2= { 
      subnet ="subnet-0cf0e3d207e47eb3a",
      size = "t2.large"},
    ec2-dani-web3= { 
      subnet ="subnet-019152f5bccbb831d",
      size = "t2.micro"}
  }
}

resource "aws_instance" "web2" {
   for_each = var.maquinas
  subnet_id = each.value.subnet
  ami = "ami-0e66f5495b4efdd0f"

  instance_type = each.value.size
  key_name = "key-private-turma3-dani-dev" # a chave que vc tem na maquina pessoal
  associate_public_ip_address = true
  vpc_security_group_ids = ["sg-0ef32fd6dc0db7e5d"]
  root_block_device {
    encrypted = true
    volume_size = 8
  }
  tags = {
    Name = "${each.key}"
  }
}*/

provider "aws" {
  region = "sa-east-1"
}

/*
variable "maquinas" {
  default     = {
    maquina1 = "ec2-teste1",
    maquina2 = "ec2-teste2",
    maquina3 = "ec2-teste3"
  }
}*/

variable "image_id" {
  type        = string
  description = "O id do Amazon Machine Image (AMI) para ser usado no servidor."

  validation {
    condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "O valor do image_id não é válido, tem que começar com \"ami-\"."
  }
}

variable "instance_type" {
  type        =  string
  description = "O tipo da instância para ser usado no servidor."

  validation {
    condition     = length(var.instance_type) > 3 && substr(var.instance_type, 0, 3) == "t2."
    error_message = "A instância não é válida, tem que começar com \"t2.\"."
  }
}

variable "nome_servidor" {
  type        =  string
  description = "O nome para ser usado no servidor."

  validation {
    condition     = length(var.nome_servidor) > 0 
    error_message = "O nome não é válido, o campo não pode ser branco."
  }
}

variable "security_group" {
  type        = string
  description = "O id da security_group para ser usado no servidor."

  validation {
    condition     = length(var.security_group) > 3 && substr(var.security_group, 0, 3) == "sg-"
    error_message = "O valor da security_group não é válido, tem que começar com \"sg-\"."
  }
}

variable "subnet_id" {
  type        = string
  description = "O id da Subnet para ser usado no servidor."

  validation {
    condition     = length(var.subnet_id) > 7 && substr(var.subnet_id, 0, 7) == "subnet-"
    error_message = "O valor da subnet_id não é válido, tem que começar com \"subnet-\"."
  }
}

variable "quantidade" {
  type        =  number
  description = "A quantidade de servidores servidor (1 a 5)."

  validation {
    condition     = var.quantidade > 0 && var.quantidade <= 5
    error_message = "A quantidade não é válida (1 a 5)."
  }
}


resource "aws_instance" "web2" {
  ami = var.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [var.security_group]
  subnet_id = var.subnet_id
  count = var.quantidade
  #count = length(keys(var.maquinas))
  #filename = "${keys(var.maquinas)[count.index]}"
  #content = var.arquivos[keys(var.arquivos)[count.index]]
  key_name = "cert-turma3-cleber-dev" # a chave que vc tem na maquina pessoal
  associate_public_ip_address = true
  root_block_device {
    encrypted = true
    volume_size = 8
  }
  tags = {
    Name = "${var.nome_servidor}-${count.index}"
  }
}
/*
output "image_id" {
    value = var.image_id
}
output "instance_type" {
    value = var.instance_type
}
output "nome_servidor" {
    value = var.nome_servidor[count.index]
}
output "quantidade" {
    value = var.quantidade
}
output "security_group" {
    value = var.security_group
}
output "subnet_id" {
    value = var.subnet_id
}
output "public_ip" {
    for_each = var.quantidade
    value = aws_instance.web2.public_ip
}
output "public_dns" {
    for_each = var.quantidade
    value = aws_instance.web2.public_dns
}
output "ssh_dns" {
    for_each = var.quantidade
    value = "ssh -i cert-turma3-cleber-dev.pem ubuntu@${aws_instance.web2.public_dns}"
}*/
output "maquinas_aws" {
    value = [
    for maq in aws_instance.web2 :
      "ssh -i cert-turma3-cleber-dev.pem ubuntu@${maq.public_dns}"
    ]
}

#resource "aws_key_pair" "chave_key" {
#  key_name   = "chave_key"
#  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABUAHUAHuaHaUhAUhAUAiqHA541BsJFngWPqlx27QdAZEWdMLvJv5Wguvatb6LIDo1V3rJ4mUtRRs0o2q3LwYiA5CIkiHFXyNVhXTF1WNAbRossUMsu/BzmgEKyIPPgPHeM0PyRi6FuW1TTZYdnO/GCzJ0UMvZFKnr2g6rELWgdc9Clxz8peNJ+iPJx/sJb+DxTuHDJc1U9eOYS7vlwzsHHApD9O+DbWnpwRpSEuX3vjm5pEEAPqrcBD3HK8kH2qMVRZNxg/fSzSrzjCwFV3ShNbKSTD6HYBV2xCY18mRFjyW94BPSBDGel7/kqTmXY4jtbAoyycWRZJFYhCdzNfItT69nHmsT3i09e0J9jNI6CaameQg/cwIOt8fl+lxUIAufHqFDJPGMJcNFoVR7t7yWPXN3qev2OlGnQONDVlNOmIJDrO+r2QeoVcKaxKye7G3HD3u4HuqGYfL9MtCo6pOZ8IZsCCj2KpS4KQCc="
#}


# /////

# aws_instance.web.public_id