# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zone
# Fetch Availability zones from AWS,

data "aws_availability_zones" "az" {
  state = "available"
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# https://developer.hashicorp.com/terraform/language/functions/cidrsubnet
#
# public subnets
resource "aws_subnet" "snipe-it-public-subnet" {
  availability_zone = element(keys(data.aws_availability_zones.az), count.index)
  count             = local.subnet_count 
  cidr_block = cidrsubnet(var.public_subnets_cidr, 4, count.index)
  map_public_ip_on_launch = true
  vpc_id     = aws_vpc.snipe-it-vpc.id
  tags = {
    Name = "$(var.name}-public-subnet"
}
}


resource "aws_subnet" "snipe-it-private-subnet" {
  count             = local.subnet_count
  availability_zone = element(keys(data.aws_availability_zones.az), count.index)
#  availability_zone = data.aws_availability_zones.az[count.index]  # Access AZ names directly
  cidr_block        = cidrsubnet(var.public_subnets_cidr, 4, count.index)
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

