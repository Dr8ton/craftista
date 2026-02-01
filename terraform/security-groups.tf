resource "aws_security_group" "sg-frontend" {
  description = "Controls access to the Frontend."
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "sg-frontend"
  }
}
resource "aws_security_group" "sg-backend" {
  description = "Controls access to the Backend"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "sg-backend"
  }
}

resource "aws_security_group" "sg-bastion" {
  description = "Controls access to the Bastion"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "sg-bastion"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.sg-frontend.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_http_out" {
    for_each = {
    "frontend" = aws_security_group.sg-frontend.id,
    "backend"  = aws_security_group.sg-backend.id
  }
  
  security_group_id = each.value
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_egress_rule" "allow_https_out" {
   for_each = {
    "frontend" = aws_security_group.sg-frontend.id,
    "backend"  = aws_security_group.sg-backend.id
  }
  
   security_group_id = each.value
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443 
}


resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.sg-bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_ingress_rule" "allow_ssh_in_from_bastion" {
  for_each = {
    "frontend" = aws_security_group.sg-frontend.id,
    "backend"  = aws_security_group.sg-backend.id
  }

  security_group_id = each.value
  cidr_ipv4         = "${aws_instance.bastion.private_ip}/32"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22

}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_from_bastion" {
  security_group_id = aws_security_group.sg-bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # This signifies all protocols
}


resource "aws_vpc_security_group_egress_rule" "egress_frontend_to_catalogue" {
  security_group_id            = aws_security_group.sg-frontend.id
  referenced_security_group_id = aws_security_group.sg-backend.id
  from_port                    = 5000
  ip_protocol                  = "tcp"
  to_port                      = 5000
}

resource "aws_vpc_security_group_egress_rule" "egress_frontend_to_recommendation" {
  security_group_id            = aws_security_group.sg-frontend.id
  referenced_security_group_id = aws_security_group.sg-backend.id
  from_port                    = 8080
  ip_protocol                  = "tcp"
  to_port                      = 8080
}

resource "aws_vpc_security_group_egress_rule" "egress_frontend_to_voting" {
  security_group_id            = aws_security_group.sg-frontend.id
  referenced_security_group_id = aws_security_group.sg-backend.id
  from_port                    = 8080
  ip_protocol                  = "tcp"
  to_port                      = 8080
}

# --- Ingress rules for backend services from frontend ---

resource "aws_vpc_security_group_ingress_rule" "ingress_from_frontend_to_catalogue" {
  description                  = "Allow traffic from frontend to catalogue service"
  security_group_id            = aws_security_group.sg-backend.id
  referenced_security_group_id = aws_security_group.sg-frontend.id
  from_port                    = 5000
  ip_protocol                  = "tcp"
  to_port                      = 5000
}

resource "aws_vpc_security_group_ingress_rule" "ingress_from_frontend_to_backend_8080" {
  description                  = "Allow traffic from frontend to recommendation and voting services"
  security_group_id            = aws_security_group.sg-backend.id
  referenced_security_group_id = aws_security_group.sg-frontend.id
  from_port                    = 8080
  ip_protocol                  = "tcp"
  to_port                      = 8080
}

