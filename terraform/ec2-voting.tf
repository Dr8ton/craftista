resource "aws_instance" "voting" {

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "craftista-key"
  vpc_security_group_ids = [aws_security_group.backend-sgs["voting"].id]
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
export CATALOGUE_SERVICE_URL="http://${aws_instance.catalogue.private_ip}:5000/api/products"
docker run -d -p 8080:8080 -e CATALOGUE_SERVICE_URL=$CATALOGUE_SERVICE_URL --restart unless-stopped dr8ton/craftista-voting
EOT


  tags = {
    Name = "voting"
  }
}

