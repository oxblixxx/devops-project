# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
# 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc

resource "aws_vpc" "snipe-it-vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  
  tags = {
    Terraform = "true"
    Environment = "test"
  }

}
