# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role

resource "aws_iam_role" "ec2-instance-role" {
name = "ec2_instance_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

#   tags = merge(
#     var.tags,
#     {
#       Name = "aws assume role"
#     },
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy

resource "aws_iam_policy" "ec2-policy" {
  name        = "ec2_instance_policy"
  description = "A test policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]

  })

#   tags = merge(
#     var.tags,
#     {
#       Name =  "aws assume policy"
#     },
#   )
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment
 resource "aws_iam_role_policy_attachment" "ec2-policy-attach" {
        role       = aws_iam_role.ec2-instance-role.id
        policy_arn = aws_iam_policy.ec2-policy.arn
    }


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile
  resource "aws_iam_instance_profile" "ec2-ip" {
        name = "aws_instance_profile_ec2-snipe-it"
        role =  aws_iam_role.ec2-instance-role.id
    }
  
    

