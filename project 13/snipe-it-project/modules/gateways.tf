# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway

resource "aws_internet_gateway" "snipe-it-igw" {
  vpc_id = module.snipe-it.id

  tags = {
    Environment = "test"
    Terraform = "true"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway_attachment

resource "aws_internet_gateway_attachment" "igw-attachment" {
  internet_gateway_id = aws_internet_gateway.snipe-it-igw.id
  vpc_id              = module.snipe-it.id
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_nat_gateway" "snipe-it-natgw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.example.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.snipe-it-igw]
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_network_interface" "private-ip-gw" {
  subnet_id   = aws_subnet.snipe-it-private-subnet.id
  private_ips = ["10.0.0.10", "10.0.0.11"]
}

resource "aws_eip" "private-subnet" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.private-ip-gw.id
  associate_with_private_ip = "10.0.0.10"
  depends_on = [aws_internet_gateway.snipe-it-igw]
}

