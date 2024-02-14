variable "cloud" {
  type = string
  validation {
    condition = contains(["aws", "azure", "gcp", "vmware"], lower(var.
    cloud))
    error_message = "You must use an approved cloud."
  }
  validation {
    condition     = lower(var.cloud) == var.cloud
    error_message = "The cloud name must not have capital letters."
  }
}

variable "no_caps" {
  type = string
  validation {
    condition     = lower(var.no_caps) == var.no_caps
    error_message = "Value must be in all lower case."
  }
}
variable "character_limit" {
  type = string
  validation {
    condition     = length(var.character_limit) == 3
    error_message = "This variable must contain only 3 characters."
  }
}
variable "ip_address" {
  type = string
  validation {
    condition = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.
    ip_address))
    error_message = "Must be an IP address of the form X.X.X.X."
  }
}


variable "phone_number" {
  type      = string
  sensitive = true
  default   = "867-5309"
}
locals {
  contact_info = {
    cloud        = var.cloud
    department   = var.no_caps
    cost_code    = var.character_limit
    phone_number = var.phone_number
  }
  my_number = nonsensitive(var.phone_number)
}
output "cloud" {
  value = local.contact_info.cloud
}
output "department" {
  value = local.contact_info.department
}
output "cost_code" {
  value = local.contact_info.cost_code
}
output "phone_number" {
  value     = local.contact_info.phone_number
  sensitive = true
}
output "my_number" {
  value = local.my_number
}


variable "us-east-1-azs" {
  type = list(string)
  default = ["us-east-1a",
    "us-east-1b",
    "us-east-1c",
    "us-east-1d",
    "us-east-1e"
  ]
}


variable "ip" {
  type = map(string)
  default = {
    prod = "10.0.150.0/24"
    dev  = "10.0.250.0/24"
  }
}

# resource "aws_subnet" "list_subnet" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = var.ip["prod"]
#   availability_zone = var.us-east-1-azs[0]
# }

variable "env" {
  type = map(any)
  default = {
    prod = {
      ip = "10.0.150.0/24"
      az = "us-east-1a"
    }
    dev = {
      ip = "10.0.250.0/24"
      az = "us-east-1e"
    }
  }
}

# resource "aws_subnet" "list_subnet" {
#   for_each          = var.env
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = each.value.ip
#   availability_zone = each.value.az
# }


variable "num_1" {
  type        = number
  description = "Numbers for function labs"
  default     = 88
}
variable "num_2" {
  type        = number
  description = "Numbers for function labs"
  default     = 73
}
variable "num_3" {
  type        = number
  description = "Numbers for function labs"
  default     = 52
}

locals {
  maximum = max(var.num_1, var.num_2, var.num_3)
  minimum = min(var.num_1, var.num_2, var.num_3, 44, 20)
}
output "max_value" {
  value = local.maximum
}
output "min_value" {
  value = local.minimum
}

