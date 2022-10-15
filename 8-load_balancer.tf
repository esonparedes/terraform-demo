# Create the load balancer
resource "aws_lb" "lb" {
  name                       = "${local.common_name}-lb"
  internal                   = true
  load_balancer_type         = "application"
  subnets                    = local.subnet_ids
  security_groups            = [aws_security_group.lb.id]
  idle_timeout               = 3600
  enable_deletion_protection = false
  drop_invalid_header_fields = true

  tags = {
    Name = "${local.common_name}-lb"
  }
}

# Create the load balancer listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  certificate_arn   = null

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

# Create the load balancer target group
resource "aws_lb_target_group" "target_group" {
  name     = "${local.common_name}-lb-tgt"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

# Attachment of the EC2 instances to the load balancer target group
resource "aws_lb_target_group_attachment" "instance_targets" {
  count            = 2
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}