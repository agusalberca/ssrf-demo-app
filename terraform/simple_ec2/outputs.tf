output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.ec2.id
}

output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.ec2.public_ip
}

output "security_group_id" {
  description = "The ID of the security group associated with the EC2 instance"
  value       = aws_security_group.ec2_sg.id
}

output "instance_arn" {
  description = "The ARN of the EC2 instance"
  value       = aws_instance.ec2.arn
}

output "subnet_id" {
  description = "The ID of the subnet where the EC2 instance is launched"
  value       = aws_instance.ec2.subnet_id
}
