# CREATE ALB
resource "aws_lb" "alb" {
  name               = "terrVPC-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [var.sg-id]
  subnets         = [var.pub-sub1-id , var.pub-sub2-id]

  tags = {
    Name = "terrVPC-alb"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "terrVPC-tg"
  port     = var.tg-port
  protocol = "HTTP"
  vpc_id   = var.vpc-id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }
}


