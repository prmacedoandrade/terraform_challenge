terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
  profile = "bia"
}

resource "aws_security_group" "bia_dev" {
  name        = "bia-dev-terraform"
  description = "Bia dev terraform security rule"
  vpc_id      = "vpc-08fbd41d57c4f621f"

  ingress {
    description = "free 3001"
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

resource "aws_instance" "bia-dev" {
  ami             = "ami-02f3f602d23f1659d"
  instance_type   = "t3.micro"
  vpc_security_group_ids = [aws_security_group.bia_dev.id]

  root_block_device {
    volume_size = 10
  }

  tags = {
    ambiente = "dev"
    Name     = "bia-dev"
  }
}