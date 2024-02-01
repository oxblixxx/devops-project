# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
# Create public route table
resource "aws_route_table" "publ-rtbl" {
  vpc_id     = aws_vpc.snipe-it-vpc.id
  

  # route {
  #   cidr_block = "10.0.1.0/24"
  #   gateway_id = aws_internet_gateway.igw.id
  # }

  tags = {
    Environment = "dev"
  }
}

# Create private route table
resource "aws_route_table" "priv-rtbl" {
  vpc_id     = aws_vpc.snipe-it-vpc.id

  tags = {
    Environment = "dev"
  }
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
# Create public route
resource "aws_route" "publ-rtbl-route" {
  route_table_id         = aws_route_table.publ-rtbl.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.snipe-it-igw.id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/main_route_table_association
# Associate public subnets to route table

resource "aws_route_table_association" "publ-subnets-assoc" {
  count          = length(aws_subnet.snipe-it-public-subnet[*].id)
  subnet_id      = element(aws_subnet.snipe-it-public-subnet[*].id, count.index)
  route_table_id = aws_route_table.publ-rtbl.id
}


# Create route for private subnets traffic

resource "aws_route" "priv-rtbl-route" {
  route_table_id         = aws_route_table.priv-rtbl.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.snipe-it-igw.id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/main_route_table_association
# Associate private subnets to route table

resource "aws_route_table_association" "priv-subnets-assoc" {
  count          = length(aws_subnet.snipe-it-private-subnet[*].id)
  subnet_id      = element(aws_subnet.snipe-it-private-subnet[*].id, count.index)
  route_table_id = aws_route_table.priv-rtbl.id
}



