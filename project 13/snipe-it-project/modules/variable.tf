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


variable "public_subnets_cidr" {
  type = string
}

variable "private_subnets_cidr" {
  type = string
}


variable "env-value" {
  default = ["test", "true"]
}

variable "env-key" {
  default = ["Terraform", "Environment"]
}

variable "cidr_block" {
  default = "10.0.0.0/24"
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