resource "aws_instance" "app_server" {
  ami           = "ami-0c1d7eb198a14f4b7"
  instance_type = "t2.micro"
  user_data = <<EOF
  
  echo "sudo apt update && sudo apt install apache2 -y" > file.sh
  sh file.sh
  # echo $(curl http://169.254.169.254/latest/meta-data/local-ipv4) > /var/www/html/index.html
  # sudo systemctl restart ngnix

  EOF

  tags = {
    Name = "Terraform"
  }
}