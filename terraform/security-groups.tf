resource "aws_security_group" "backend-sgs" {
  for_each    = var.backend_application_services
  description = "Security Group for the ${each.key} service"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "sg-${each.key}"
  }
}


resource "aws_security_group" "sg-frontend" {
  description = "Controls access to the Frontend."
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "sg-frontend"
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

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.sg-bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_from_bastion" {
  security_group_id = aws_security_group.sg-bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # This signifies all protocols
}

# Allow SSH from bastion to the static frontend SG
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_in_from_bastion_to_frontend" {
  security_group_id            = aws_security_group.sg-frontend.id
  referenced_security_group_id = aws_security_group.sg-bastion.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
}

# Allow SSH from bastion to all dynamic backend SGs
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_in_from_bastion_to_backend" {
  for_each = aws_security_group.backend-sgs

  security_group_id            = each.value.id
  referenced_security_group_id = aws_security_group.sg-bastion.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_http_out_from_frontend" {
  security_group_id = aws_security_group.sg-frontend.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_egress_rule" "allow_https_out_from_frontend" {

  security_group_id = aws_security_group.sg-frontend.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_http_out_from_backend" {

  for_each          = aws_security_group.backend-sgs
  security_group_id = each.value.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_egress_rule" "allow_https_out_from_backend" {
  for_each          = aws_security_group.backend-sgs
  security_group_id = each.value.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
resource "aws_vpc_security_group_ingress_rule" "allow_http_in_from_frontend_to_backend" {
  for_each                     = var.backend_application_services
  security_group_id            = aws_security_group.backend-sgs[each.key].id
  referenced_security_group_id = aws_security_group.sg-frontend.id
  ip_protocol                  = "tcp"
  from_port                    = each.value.port
  to_port                      = each.value.port
}

resource "aws_vpc_security_group_egress_rule" "allow_http_out_from_frontend_to_backend" {
  for_each                     = var.backend_application_services
  security_group_id            = aws_security_group.sg-frontend.id
  referenced_security_group_id = aws_security_group.backend-sgs[each.key].id
  from_port                    = each.value.port
  ip_protocol                  = "tcp"
  to_port                      = each.value.port
}

resource "aws_vpc_security_group_egress_rule" "allow_voting_out_to_catalogue" {
  security_group_id            = aws_security_group.backend-sgs["voting"].id
  referenced_security_group_id = aws_security_group.backend-sgs["catalogue"].id
  ip_protocol                  = "tcp"
  from_port                    = var.backend_application_services["catalogue"].port
  to_port                      = var.backend_application_services["catalogue"].port
}

resource "aws_vpc_security_group_ingress_rule" "allow_catalogue_in_from_voting" {
  security_group_id            = aws_security_group.backend-sgs["catalogue"].id
  referenced_security_group_id = aws_security_group.backend-sgs["voting"].id
  ip_protocol                  = "tcp"
  from_port                    = var.backend_application_services["catalogue"].port
  to_port                      = var.backend_application_services["catalogue"].port
}
