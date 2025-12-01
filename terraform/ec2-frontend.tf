resource "aws_instance" "frontend" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "craftista-key"
  vpc_security_group_ids = [aws_security_group.sg-frontend.id]
  subnet_id              = aws_subnet.public.id
  user_data              = <<EOT
#!/bin/bash
apt-get update -y
apt-get install -y docker.io
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu
EOT


  tags = {
    Name = "frontend"
  }
}

resource "aws_eip" "eip-frontend" {
  instance = aws_instance.frontend.id
  domain   = "vpc"
}