variable "azs" {
  type = string
}

variable "subnet_number" {
  type  = string
}

variable "private_subnets" {
  type = string
}

variable "public_subnets_cidr" {
  type = "string"
}

variable "env-value" {
  default = ["test", "true"]
}

variable "env-key" {
  default = ["Terraform", "Environment"]
}

variable "cidr_block" {
  default = "10.0.0.0/24"
  type = number
}

variable "ami-image" {
  default = "ami-0fc5d935ebf8bc3bc"
}

variable "name" {
  type = string
  default = "snipe-it"
}