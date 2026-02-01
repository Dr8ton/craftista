resource "aws_instance" "catalogue" {

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "craftista-key"
  vpc_security_group_ids = [aws_security_group.sg-backend.id]
  subnet_id              = aws_subnet.private.id
  user_data              = <<EOT
#!/bin/bash
until curl -s --head http://www.google.com | head -n 1 | grep "200 OK" > /dev/null; do
  echo "Waiting for network..."
  sleep 5
done

echo "Network is up, proceeding with installation."
apt-get update -y
apt-get install -y docker.io
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu
docker run -d -p 5000:5000 --restart unless-stopped dr8ton/craftista-catalogue
EOT


  tags = {
    Name = "catalogue"
  }
}

