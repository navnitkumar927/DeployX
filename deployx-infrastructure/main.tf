resource "aws_instance" "deployx" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id = var.subnet_id

  vpc_security_group_ids = [
    var.security_group_id
  ]

  associate_public_ip_address = true

  user_data = templatefile("${path.module}/user-data.sh", {
    gitlab_repo = var.gitlab_repo
    git_branch  = var.git_branch
  })

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name    = var.project_name
    Project = "DeployX"
  }
}