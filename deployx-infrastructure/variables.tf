variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for DeployX EC2"
  type        = string
}

variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Existing subnet ID"
  type        = string
}

variable "security_group_id" {
  description = "Existing security group ID"
  type        = string
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "project_name" {
  description = "EC2 instance name"
  type        = string
  default     = "DeployX"
}

variable "gitlab_repo" {
  description = "GitLab repository URL"
  type        = string
}

variable "git_branch" {
  description = "GitLab branch"
  type        = string
  default     = "main"
}