# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zone
# Fetch Availability zones from AWS,

data "aws_availability_zones" "az" {}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# https://developer.hashicorp.com/terraform/language/functions/cidrsubnet
#
# public subnets
resource "aws_subnet" "snipe-it-public-subnet" {
  availability_zone = element(data.aws_availability_zones.az.names, count.index)
  #availability_zone = element(keys(data.aws_availability_zones.az), count.index)
  # availability_zone = var.az_number[data.aws_availability_zone.az.name_suffix, count.index)
  count             = local.subnet_count 
  cidr_block = cidrsubnet(var.vpc_cidr_block, 4, count.index *2)
  map_public_ip_on_launch = true
  vpc_id     = aws_vpc.snipe-it-vpc.id
  tags = {
    Name = "$(var.name}-public-subnet"
}
}


resource "aws_subnet" "snipe-it-private-subnet" {
  count             = local.subnet_count
  availability_zone = element(data.aws_availability_zones.az.names, count.index)
#  availability_zone = data.aws_availability_zones.az[count.index]  # Access AZ names directly
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 3, count.index * 2)
  vpc_id     = aws_vpc.snipe-it-vpc.id
  # ... other configuration ...
}


# resource "aws_subnet" "snipe-it-private-subnet" {
#   availability_zone = length(data.aws_availability_zones.az[count.index])
#   count = var.subnet_number == null ? length(data.aws_availability_zones.az[count.index]) : var.subnet_number 
#   cidr_block = cidrsubnet(var.public_subnets_cidr, 4, count.index)

#   tags = {
#     Name = "$(var.name}-private-subnet"
#   }
# }

