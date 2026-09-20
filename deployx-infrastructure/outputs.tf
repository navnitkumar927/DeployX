output "instance_id" {
  description = "DeployX EC2 instance ID"
  value       = aws_instance.deployx.id
}

output "instance_public_ip" {
  description = "DeployX EC2 public IP"
  value       = aws_instance.deployx.public_ip
}

output "instance_public_dns" {
  description = "DeployX EC2 public DNS"
  value       = aws_instance.deployx.public_dns
}

output "ssh_command" {
  description = "SSH command"
  value       = "ssh -i YOUR_KEY.pem ubuntu@${aws_instance.deployx.public_ip}"
}