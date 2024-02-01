# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "bastion-host" {
  ami           = var.ami # us-west-2
  instance_type = var.instance-type
  count = local.subnet_count
  associate_public_ip_address = true

  network_interface {
    network_interface_id = aws_network_interface.net-if[count.index].id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}


resource "aws_instance" "web-server" {
  count = local.subnet_count 
  ami           = var.ami
  instance_type = var.instance-type

  network_interface {
    network_interface_id = aws_network_interface.net-if[count.index].id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}




resource "aws_network_interface" "net-if" {
  count = local.subnet_count
  subnet_id       = aws_subnet.snipe-it-public-subnet[count.index].id
  private_ips     = ["10.0.0.50"]
  security_groups = [aws_security_group.bastion_sg.id]

  # attachment {
  #   instance     = aws_instance.bastion-host.id
  #   device_index = 1
  # }
}

resource "aws_network_interface_attachment" "net-if-attach" {
  count = local.subnet_count
  instance_id          = aws_instance.bastion-host[count.index].id
  network_interface_id = aws_network_interface.net-if[count.index].id
  device_index         = 0
}