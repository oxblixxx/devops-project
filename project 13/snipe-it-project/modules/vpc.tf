# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
# 

module "snipe-it" {
  source = "terraform-aws-modules/vpc/aws"
  azs             = length(var.azs)
  cidr = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  name = var.name
  private_subnets = length(var.private_subnets_cidr)
  public_subnets  = length(var.public_subnets_cidr)



  tags = {
    Terraform = "true"
    Environment = "test"
  }
}

