#  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
resource "aws_db_subnet_group" "snipe-it-rds-subnet" {
  count = local.subnet_count
  name       = "snipe-it-rds-subnet"
  subnet_ids = [aws_subnet.snipe-it-private-subnet[count.index].id,
                aws_subnet.snipe-it-private-subnet[count.index].id
                ]

  tags = merge(
    # var.tags,
    # {
    #   Name = "ACS-rds"
    # },
  )
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
# ---- Create the RDS instance with the subnets group
resource "aws_db_instance" "snipe-it-rds" {
  count = local.subnet_count
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  username               = var.master-username
  password               = var.master-password
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.snipe-it-rds-subnet[count.index].name
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.datalayer-sg.id]
  multi_az               = "true"
}
