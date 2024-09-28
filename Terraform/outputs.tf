# Outputs for the AWS VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

# Outputs for the AWS Subnet
output "subnet_id" {
  description = "The ID of the Subnet"
  value       = aws_subnet.subnet.id
}

# Outputs for the EC2 Instance
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.vm.id
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.vm.public_ip
}

# General Tags Outputs
output "environment" {
  description = "The environment tag"
  value       = var.environment
}