# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
# 

module "snipe-it" {
  source = "terraform-aws-modules/vpc/aws"
  azs             = length(var.azs)
  cidr = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  name = var.name
#  private_subnets = length(var.private_subnets)
  public_subnets  = length(var.public_subnets)



  tags = {
    Terraform = "true"
    Environment = "test"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = module.snipe-it.id

  tags = {
    Environment = "test"
    Terraform = "true"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway_attachment

resource "aws_internet_gateway_attachment" "igw-attachment" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id              = module.snipe-it.id
}
