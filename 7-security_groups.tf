# Security group for the EC2 Instances
resource "aws_security_group" "web" {
  name        = "${local.common_name}-web-sg"
  description = "${local.common_name}-web-sg (terraform-managed)"
  vpc_id      = aws_vpc.myvpc.id

  tags = {
    Name = "${local.common_name}-web-sg"
  }
}

# Security group rule for EC2 Instances
resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.web.id

  description = "allow ssh"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # for the sake of this demo, we allow this CIDR blocks, but in Prod - THIS IS NOT ADVISABLE.
}

# Security group for the load balancer
resource "aws_security_group" "lb" {
  name        = "${local.common_name}-lb-sg"
  description = "${local.common_name}-lb-sg (terraform-managed)"
  vpc_id      = aws_vpc.myvpc.id

  tags = {
    Name = "${local.common_name}-lb-sg"
  }
}

# Security group rule for the load balancer
resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  security_group_id = aws_security_group.lb.id

  description = "allow http"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # for the sake of this demo, we allow this CIDR blocks, but in Prod - THIS IS NOT ADVISABLE.
}