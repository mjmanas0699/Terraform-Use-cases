resource "aws_instance" "app_server" {
  ami           = "ami-08df646e18b182346"
  instance_type = "t2.micro"
  user_data = <<EOF
  echo "sudo apt update && sudo apt install apache2 -y" > file.sh
  sh file.sh
  EOF

  tags = {
    Name = "Terraform"
  }
}