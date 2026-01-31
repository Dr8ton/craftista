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
export VOTING_URL="http://${aws_instance.voting.private_ip}:8080"
export CATALOGUE_URL="http://${aws_instance.catalogue.private_ip}:5000"
export RECOMMENDATION_URL="http://${aws_instance.recommendation.private_ip}:8080"
docker run -d -p 80:3000 -e CATALOGUE_URL=$CATALOGUE_URL -e VOTING_URL=$VOTING_URL -e RECOMMENDATION_URL=$RECOMMENDATION_URL --restart unless-stopped dr8ton/craftista-frontend
EOT


  tags = {
    Name = "frontend"
  }
}

resource "aws_eip" "eip-frontend" {
  instance = aws_instance.frontend.id
  domain   = "vpc"
}