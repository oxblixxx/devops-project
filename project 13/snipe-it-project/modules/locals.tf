
locals {
  subnet_count = var.subnet_number == null ? length(data.aws_availability_zones.az) : var.subnet_number
}