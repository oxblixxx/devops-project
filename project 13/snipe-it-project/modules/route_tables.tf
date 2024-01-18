# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table

resource "aws_route_table" "RTbl" {
  vpc_id = module.snipe-it-vpc.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Environment = "dev"
  }
}




resource "aws_route_table_association" "a" {
  count = length(var.public_subnets)
  subnet_id      = module.snipe-it-vpc.public_subnets[2]
  route_table_id = aws_route_table.bar.id
}