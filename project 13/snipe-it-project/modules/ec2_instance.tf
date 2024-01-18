# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

resource "aws_instance" "bastion-host" {
  ami           = var.ami-image # us-west-2
  instance_type = "t2.micro"
  
  associate_public_ip_address = true


  network_interface {
    network_interface_id = aws_network_interface.net-if.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}


resource "aws_instance" "web-server" {
  ami           = var.ami-image 
  instance_type = "t2.micro"
  
  network_interface {
    network_interface_id = aws_network_interface.net-if.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}



resource "aws_network_interface" "net-if" {
  count = length(var.public_subnets)

  subnet_id       = module.snipe-it-vpc.public_subnets[2]
  private_ips     = ["10.0.0.50"]
  security_groups = [aws_security_group.web.id]

  attachment {
    instance     = aws_instance.test.id
    device_index = 1
  }
}

resource "aws_network_interface_attachment" "net-if-attach" {
  instance_id          = aws_instance.bastion-host.id
  network_interface_id = aws_network_interface.net-if.id
  device_index         = 0
}