# Crie um grupo de segurança
resource "aws_security_group" "this" {
  name        = format("%s-sg", var.cluster_name)
  vpc_id      = var.vpc_id
  description = "Allow inbound traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = format("%s-sg", var.cluster_name)
  }
}


resource "aws_vpc_security_group_ingress_rule" "web" {
  security_group_id = aws_security_group.this.id

  cidr_ipv4   = "10.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
  description = "Acesso Web"
}

resource "aws_vpc_security_group_ingress_rule" "container" {
  security_group_id = aws_security_group.this.id

  cidr_ipv4   = "10.0.0.0/0"
  from_port   = 8000
  ip_protocol = "tcp"
  to_port     = 8000
  description = "Acesso Web"
}
