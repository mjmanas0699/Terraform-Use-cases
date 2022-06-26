resource "aws_instance" "app_server" {
  ami           = "ami-068257025f72f470d"
  instance_type = "t2.micro"
  associate_public_ip_address = "false"
  key_name = "test"
  user_data = <<EOF
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
resource "aws_lb_target_group" "server" {
  name     = "example-lb-tg"
  port     = 80
  protocol = "HTTP"
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.server.arn
  target_id        = aws_instance.app_server.id
  port             = 80
  depends_on       = [aws_lb_target_group.server]
}
