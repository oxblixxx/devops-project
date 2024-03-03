# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway

resource "aws_internet_gateway" "snipe-it-igw" {
  vpc_id     = aws_vpc.snipe-it-vpc.id

  tags = {
    Environment = "test"
    Terraform = "true"
  }
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_nat_gateway" "snipe-it-natgw" {
  count = local.subnet_count
  allocation_id = aws_eip.nat-eip[count.index].id
  subnet_id     = aws_subnet.snipe-it-private-subnet[count.index].id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
 # depends_on = [aws_internet_gateway.snipe-it-igw]
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_network_interface" "private-ip-gw" {
  count = local.subnet_count
  subnet_id   = aws_subnet.snipe-it-private-subnet[count.index].id
  private_ips = ["192.168.0.20", "192.168.0.21"]
}

resource "aws_eip" "nat-eip" {
  count = local.subnet_count
  domain                    = "vpc"
  network_interface         = aws_network_interface.private-ip-gw[count.index].id
  associate_with_private_ip = "192.168.0.20"
  #depends_on = [aws_internet_gateway.snipe-it-igw]
}

