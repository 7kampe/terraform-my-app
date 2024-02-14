terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.0.0, < 3.1.0"
    }
  }
}


# Configure the Random Provider
provider "random" {
  # Configuration options
}


# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

#Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

# module "website_s3_bucket" {
#   source      = "./modules/aws-s3-static-website-bucket"
#   bucket_name = var.s3_bucket_name
#   aws_region  = "us-east-1"
#   tags = {
#     Terraform   = "true"
#     Environment = "certification"
#   }
# }

# module "subnet_addrs" {
#   source          = "hashicorp/subnets/cidr"
#   version         = "1.0.0"
#   base_cidr_block = "10.0.0.0/22"
#   networks = [
#     {
#       name     = "module_network_a"
#       new_bits = 2
#     },
#     {
#       name     = "module_network_b"
#       new_bits = 2
#     },
#   ]
# }

# output "subnet_addrs" {
# value = module.subnet_addrs.network_cidr_blocks
# }


resource "tls_private_key" "generated" {
  algorithm = "RSA"
}
resource "local_file" "private_key_pem" {
  content  = tls_private_key.generated.private_key_pem
  filename = "MyAWSKey.pem"
}

resource "aws_key_pair" "generated" {
  key_name   = "MyAWSKey"
  public_key = tls_private_key.generated.public_key_openssh

  lifecycle {
    ignore_changes = [key_name]
  }
}


module "server" {
  source    = "./modules/server"
  ami       = data.aws_ami.amazon_linux.id
  subnet_id = aws_subnet.public_subnets["public_subnet_1"].id
  security_groups = [
    aws_security_group.vpc-ping.id,
    aws_security_group.ingress-ssh.id,
    aws_security_group.vpc-web.id
  ]

}

module "server_subnet_1" {
  source      = "./modules/web_server"
  ami         = data.aws_ami.amazon_linux.id
  key_name    = aws_key_pair.generated.key_name
  user        = "ec2-user"
  private_key = tls_private_key.generated.private_key_pem
  subnet_id   = aws_subnet.public_subnets["public_subnet_1"].id
  security_groups = [aws_security_group.vpc-ping.id,
    aws_security_group.ingress-ssh.id,
  aws_security_group.vpc-web.id]
}

output "public_ip" {
  value = module.server.public_ip
}
output "public_dns" {
  value = module.server.public_dns
}


module "autoscaling" {

  source  = "terraform-aws-modules/autoscaling/aws"
  version = "4.9.0"
  #source  = "github.com/terraform-aws-modules/terraform-aws-autoscaling?ref=v4.9.0"

  # Autoscaling group
  name                = "myasg"
  vpc_zone_identifier = [aws_subnet.private_subnets["private_subnet_1"].id]
  min_size            = 0
  max_size            = 1
  desired_capacity    = 1
  # Launch template
  use_lt        = true
  create_lt     = true
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  tags_as_map = {
    Name = "Web EC2 Server 2"
  }
}



