# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system
# ---- Create Elastic file system
resource "aws_efs_file_system" "snipe-it-efs" {
  encrypted  = true
  kms_key_id = aws_kms_key.snipe-it-kms.arn

#   tags = merge(
#     var.tags,
#     {
#       Name = "ACS-efs"
#     },
#   )
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/efs_mount_target
# ---- Set first mount target for the EFS 
resource "aws_efs_mount_target" "subnet-1" {
  count = local.subnet_count
  file_system_id  = aws_efs_file_system.snipe-it-efs.id
  subnet_id       = aws_subnet.snipe-it-private-subnet[count.index].id
  security_groups = [aws_security_group.datalayer-sg.id]
}

# ---- Set second mount target for the EFS 
resource "aws_efs_mount_target" "subnet-2" {
  count = local.subnet_count
  file_system_id  = aws_efs_file_system.snipe-it-efs.id
  subnet_id       = aws_subnet.snipe-it-private-subnet[count.index].id
  security_groups = [aws_security_group.datalayer-sg.id]
}


# ---- Set second mount target for the EFS 
resource "aws_efs_mount_target" "subnet-3" {
  count = local.subnet_count
  file_system_id  = aws_efs_file_system.snipe-it-efs.id
  subnet_id       = aws_subnet.snipe-it-private-subnet[count.index].id
  security_groups = [aws_security_group.datalayer-sg.id]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/efs_access_point
# ---- Create access point for snipe-it
resource "aws_efs_access_point" "snipe-it" {
  file_system_id = aws_efs_file_system.snipe-it-efs.id

  posix_user {
    gid = 0
    uid = 0
  }

  root_directory {
    path = "/snipe-it"

    creation_info {
      owner_gid   = 0
      owner_uid   = 0
      permissions = 0755
    }

  }

}