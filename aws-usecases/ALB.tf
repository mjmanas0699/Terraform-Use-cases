resource "aws_instance" "app_server" {
  ami           = "ami-08df646e18b182346"
  instance_type = "t2.micro"
  user_data = <<EOF
  #!/bin/bash
  sudo amazon-linux-extras install nginx1 -y
  echo $(curl http://169.254.169.254/latest/meta-data/local-ipv4) > /usr/share/nginx/html/index.html
  sudo systemctl start nginx
  EOF

  tags = {
    Name = "Terraform"
  }
}