variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "vpc_name" {
  type    = string
  default = "DemoVPC_Terraform"
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "private_subnets" {
  default = {
    "private_subnet_1" = 1
  }
}
variable "public_subnets" {
  default = {
    "public_subnet_1" = 1
  }
}

variable "variables_sub_cidr" {
  description = "CIDR Block for the Variables Subnet"
  type        = string
  default     = "10.0.202.0/24"
}
variable "variables_sub_az" {
  description = "Availability Zone used Variables Subnet"
  type        = string
  default     = "eu-central-1a"
}
variable "variables_sub_auto_ip" {
  description = "Set Automatic IP Assigment for Variables Subnet"
  type        = bool
  default     = true
}

variable "environment" {
  type    = string
  default = "terraform-test"
}

variable "test_for_git" {
  type    = string
  default = "test for git"
}

locals {
  team        = "api_mgmt_test_team"
  application = "test_terraform_corp_api"
  server_name = "ec2-${var.environment}-api-${var.variables_sub_az}"
}