resource "aws_instance" "app_server" {
  ami           = "ami-068257025f72f470d"
  instance_type = "t2.micro"
  key_name = "test"
  user_data = <<EOF
#!/bin/bash
sudo -s
sudo apt install nginx -y
# echo $(curl http://169.254.169.254/latest/meta-data/local-ipv4) > /var/www/html/index.html
# systemctl restart nginx
EOF

  tags = {
    Name = "Terraform"
  }
}