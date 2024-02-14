resource "random_string" "random" {
  length = 16
}

# module "s3-bucket_example_complete" {
#   source  = "terraform-aws-modules/s3-bucket/aws//examples/complete"
#   version = "2.10.0"
# }

# terraform {
#   backend "remote" {
#     hostname     = "app.terraform.io"
#     organization = "test-kamil"
#     workspaces {
#       name = "my-aws-app"
#     }
#   }
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 3.0"
#     }
#   }
# }



variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

provider "aws" {
  region = var.aws_region
}

# terraform {
#   backend "local" {
#     path = "terraform.tfstate"
#   }
# }


locals {
  service_name = "Automation"
  app_team     = "Cloud Team"
  createdby    = "terraform"
}



# #Deploy the private subnets
# resource "aws_subnet" "private_subnets" {
# for_each = var.private_subnets
# vpc_id = aws_vpc.vpc.id
# #########cidr_block = cidrsubnet(var.vpc_cidr, 8, each.value)##########
# availability_zone = tolist(data.aws_availability_zones.available.names)[
# each.value]
# tags = {
# Name = each.key
# Terraform = "true"
# }
# }


resource "aws_security_group" "main" {
  name   = "core-sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    description = "Port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Convert Security Group to use dynamic block 
# locals {
#   ingress_rules = [{
#     port        = 443
#     description = "Port 443"
#     },
#     {
#       port        = 80
#       description = "Port 80"
#     }
#   ]
# }
# resource "aws_security_group" "main" {
#   name   = "core-sg"
#   vpc_id = aws_vpc.vpc.id
#   dynamic "ingress" {
#     for_each = local.ingress_rules
#     content {
#       description = ingress.value.description
#       from_port   = ingress.value.port
#       to_port     = ingress.value.port
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
#lifecycle {
#create_before_destroy = true
#prevent_destroy = true
#}
# }