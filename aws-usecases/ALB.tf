resource "aws_instance" "app_server" {
  ami                         = "ami-068257025f72f470d"
  instance_type               = "t2.micro"
  associate_public_ip_address = "false"
  key_name                    = "test"
  user_data                   = <<EOF
#!/bin/bash
sudo -s
sudo apt install nginx -y
echo $(curl http://169.254.169.254/latest/meta-data/local-ipv4) > /var/www/html/index.html
sudo systemctl restart nginx
EOF

  tags = {
    Name = "Terraform"
  }
}
resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["subnet-02b3dd105b1fb0e33", "subnet-0fff2c4a5a7501ba8", "subnet-0b31198f213e44561"]

}

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
