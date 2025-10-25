resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc" # Required for EIPs in a VPC

  tags = {
    Name = "craftista-nat-gateway-eip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public.id

  depends_on = [
    aws_internet_gateway.main
  ]

  tags = {
    Name = "craftista-nat-gateway"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "craftista-igw"
  }
}
