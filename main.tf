terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.53"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
  profile = "bia"
}

resource "aws_security_group" "bia_dev" {
  name        = "bia-dev"
  description = "access to bia-dev"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "ssh-access" {
   description = "Allows ssh access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol = "tcp"
    cidr_blocks = ["177.181.191.222/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "bia-dev" {
  ami             = "ami-0427090fd1714168b"
  instance_type   = "t3.micro"
  vpc_security_group_ids = [aws_security_group.bia_dev.id, aws_security_group.ssh-access.id]
  iam_instance_profile = aws_iam_instance_profile.role_acesso_ssm.name
  
  subnet_id = local.subnet_zone_b
  associate_public_ip_address = true
  #ipv6_address_count = 1

  key_name = "ssh-challenge"

  root_block_device {
    volume_size = 10
  }

  tags = {
    ambiente = "dev"
    Name     = var.instance_name
  }

  user_data = "${file("userdata_biadev.sh")}"

}