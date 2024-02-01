# create an ALB to balance the traffic between the Instances

resource "aws_lb" "ext-alb" {
  name     = "ext-alb"
  internal = false
  security_groups = [
    aws_security_group.ext-lb-sg.id,
  ]

  subnets = [
    aws_subnet.public[0].id,
    aws_subnet.public[1].id
  ]

  #    tags = merge(
  #     var.tags,
  #     {
  #       Name = "ACS-ext-alb"
  #     },
  #   )

  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}


# Create target groups
resource "aws_lb_target_group" "snipe-it-tgt" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  name        = "snipe-it-tgt"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id     = aws_vpc.snipe-it-vpc.id
  
}


# Create a listener rule
resource "aws_lb_listener" "snipe-it-listner" {
  load_balancer_arn = aws_lb.ext-alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.oyindamola.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.snipe-it-tgt.arn
  }
}



#---------------------------
# Internal Load Balancer
#---------------------------

resource "aws_lb" "int-lb" {
  name     = "ialb"
  internal = true
  security_groups = [
    aws_security_group.int-lb-sg.id,
  ]

  subnets = [
    aws_subnet.private[0].id,
    aws_subnet.private[1].id
  ]

  # tags = merge(
  #   var.tags,
  #   {
  #     Name = "ACS-int-alb"
  #   },
  # )

  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}


resource "aws_lb_target_group" "wordpress-tgt" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "wordpress-tgt"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id     = aws_vpc.snipe-it-vpc.id
}



resource "aws_lb_listener" "web-listener" {
  load_balancer_arn = aws_lb.ialb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.oyindamola.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress-tgt.arn
  }
}

