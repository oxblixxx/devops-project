                                                #-----------------#
                                                #-----AUTO--------#
                                                #----SCALING------#
                                                #----GROUP--------# 




# https://docs.aws.amazon.com/sns/?icmpid=docs_homepage_appintegration
# Creating sns topic for all the auto scaling groups
resource "aws_sns_topic" "asg-sns" {
  name = "Default_CloudWatch_Alarms_Topic"
}


# ---- Creating notification for all ASG.
resource "aws_autoscaling_notification" "asg-notifications" {
  group_names = [
    aws_autoscaling_group.snipe-it-asg,
    aws_autoscaling_group.bastion-asg
  ]  
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.asg-sns.arn
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region
# data "aws_region" "az" {
#   name = "us-east-1"
# }


# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle
# ---- Launch templates for bastion host
# resource "random_shuffle" "az-list" {
#   input = data.aws_region.az.name
# }


resource "aws_key_pair" "snipe-it-kp" {
  key_name   = "deployer-key"
  public_key = "var.public-key"
}

resource "aws_launch_template" "bastion-launch-template" {
  image_id               = var.ami
  count = local.subnet_count
  instance_type          = var.instance-type
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2-ip.id
  }

  key_name = aws_key_pair.snipe-it-kp.key_name

  placement {
  availability_zone = element(keys(data.aws_availability_zones.az), count.index)

#    availability_zone = "random_shuffle.az-list.result"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    #    tags = merge(
    #     var.tags,
    #     {
    #       Name = "bastion-launch-template"
    #     },
    #  )
  }

  user_data = filebase64("${path.module}/bastion.sh")
}


# ---- Autoscaling for bastion  hosts

resource "aws_autoscaling_group" "bastion-asg" {
  name                      = "bastion-asg"
  count = local.subnet_count
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1

  vpc_zone_identifier = [
    aws_subnet.snipe-it-public-subnet[count.index].id,
    aws_subnet.snipe-it-public-subnet[count.index].id
  ]

  launch_template {
    id      = aws_launch_template.bastion-launch-template[count.index].id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "bastion-launch-template"
    propagate_at_launch = true
  }

}

# resource "aws_autoscaling_attachment" "asg-attachment-bastion" {
#   count = local.subnet_count
#   autoscaling_group_name = aws_autoscaling_group.bastion-asg[count.index].id
#   lb_target_group_arn    = aws_lb_target_group.bastion-tgt.arn
# }





# ---- Launch template for snipe-it

resource "aws_launch_template" "snipe-it-launch-template" {
  image_id               = var.ami
  instance_type          = var.instance-type
  vpc_security_group_ids = [aws_security_group.webserver-sg.id]
  count = local.subnet_count
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2-ip.id
  }

  key_name = aws_key_pair.snipe-it-kp.key_name

  placement {
  availability_zone = element(keys(data.aws_availability_zones.az), count.index)
 
 #   availability_zone = "random_shuffle.az-list.result"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    #     tags = merge(
    #     var.tags,
    #     {
    #       Name = "wordpress-launch-template"
    #     },
    #   )
  }

  user_data = filebase64("${path.module}/bastion.sh")
}

# ---- Autoscaling for wordpress application

resource "aws_autoscaling_group" "snipe-it-asg" {
  name                      = "snipe-it-asg"
  count = local.subnet_count
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  vpc_zone_identifier = [

    aws_subnet.snipe-it-private-subnet[count.index].id,
    aws_subnet.snipe-it-private-subnet[count.index].id
  ]

  launch_template {
    id      = aws_launch_template.snipe-it-launch-template[count.index].id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "snipe-it-asg"
    propagate_at_launch = true
  }
}

# ---- Attaching autoscaling group of  snipe-it application to internal loadbalancer
resource "aws_autoscaling_attachment" "asg-attachment-snipe-it" {
  count = local.subnet_count
  autoscaling_group_name = aws_autoscaling_group.snipe-it-asg[count.index].id
  lb_target_group_arn    = aws_lb_target_group.snipe-it-tgt.arn
}




