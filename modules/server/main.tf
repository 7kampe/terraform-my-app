resource "aws_instance" "web" {
  ami                    = var.ami
  instance_type          = var.size
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_groups
  tags = {
    "Name"        = "Server from Module"
    "Environment" = "Training"
  }
}

module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.11.1"
}
output "s3_bucket_name" {
  value = module.s3-bucket.s3_bucket_bucket_domain_name
}

# module "vpc" {
#   source             = "terraform-aws-modules/vpc/aws"
#   name               = "my-vpc-terraform"
#   cidr               = "10.0.0.0/16"
#   azs                = ["us-east-1a", "us-east-1b", "us-east-1c"]
#   private_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#   public_subnets     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
#   enable_nat_gateway = true
#   enable_vpn_gateway = true
#   tags = {
#     Name        = "VPC from Module"
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }