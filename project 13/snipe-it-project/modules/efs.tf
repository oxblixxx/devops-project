# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system
# Create Elastic file system
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

# set first mount target for the EFS 
resource "aws_efs_mount_target" "subnet-1" {
  file_system_id  = aws_efs_file_system.ACS-efs.id
  subnet_id       = aws_subnet.private[2].id
  security_groups = [aws_security_group.datalayer-sg.id]
}

# set second mount target for the EFS 
resource "aws_efs_mount_target" "subnet-2" {
  file_system_id  = aws_efs_file_system.ACS-efs.id
  subnet_id       = aws_subnet.private[3].id
  security_groups = [aws_security_group.datalayer-sg.id]
}

# create access point for wordpress
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