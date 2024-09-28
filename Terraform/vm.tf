resource "aws_instance" "vm" {
  count           = var.number_of_instances
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.subnet.id
  key_name        = var.key_name
  security_groups = [aws_security_group.vm_sg.name]

  tags = {
    Name        = element(var.instance_names, count.index)
    Environment = var.environment
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from $(hostname)" > /var/www/html/index.html
              EOF
}