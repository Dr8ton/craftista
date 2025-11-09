data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "craftista-key"
  vpc_security_group_ids = [aws_security_group.sg-bastion.id]
  subnet_id = aws_subnet.public.id

  tags = {
    Name = "bastion"
  }
}

resource "aws_eip" "eip-bastion" {
  instance = aws_instance.bastion.id
  domain   = "vpc"
}