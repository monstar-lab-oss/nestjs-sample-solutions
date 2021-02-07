resource "aws_security_group" "lb" {
  name        = "${var.env}-${var.project_name}-backend-lb"
  description = "Backend Loadbalancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allow_http_from
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allow_http_from
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "backend" {
  name            = "${var.env}-${var.project_name}-backend"
  security_groups = [aws_security_group.lb.id]
  subnets         = var.public_subnet_ids

  tags = {
    Env = var.env
  }
}

resource "aws_lb_target_group" "backend" {
  name        = "${var.env}-${var.project_name}-backend"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled = true
    path    = "/api/v1"
    port    = 3000
    matcher = "200"
  }
}

resource "aws_lb_listener" "backend_http" {
  load_balancer_arn = aws_lb.backend.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}
