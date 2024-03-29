# variable "azs" {
#   type = string
# }

variable "aws_region" {
  default = "us-east-1"
}

variable "subnet_number" {
  type = string
}

# variable "private_subnets" {
#   type = string
# }

# variable "public_subnets" {
#   type = string
# }

# variable "public_subnets_cidr" {
#   type = string
#   default = "172.31.0.0/16"  // Assuming this is the correct CIDR block
# }

# variable "private_subnets_cidr" {
#   type = string
#   default = "192.168.0.0/16" 
# }


variable "env-value" {
  default = ["test", "true"]
}

variable "env-key" {
  default = ["Terraform", "Environment"]
}

variable "vpc_cidr_block" {
  default = "172.31.0.0/16"
  type    = string
}

variable "ami" {
  default = "ami-0fc5d935ebf8bc3bc"
  type    = string
}

variable "name" {
  type    = string
  default = "snipe-it"
}

# RDS
variable "master-username" {
  type        = string
  description = "Snipe-it DB master username "
}

variable "master-password" {
  type        = string
  description = "Snipe-it DB master password"
}

variable "public-key" {
  type        = string
  description = "Snipe-it public key"
}


variable "instance-type" {
  type        = string
  description = "Compute engine instance type"
}

variable "account_no" {
  description = "aws account id"
}