resource "aws_lb_target_group" "server" {
  name     = "example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0f860e2d1cb397afb"
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.server.arn
  target_id        = aws_instance.app_server.id
  port             = 80
  depends_on       = [aws_lb_target_group.server]
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.server.arn
  }
}
