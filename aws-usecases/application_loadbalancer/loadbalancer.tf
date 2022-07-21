resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["subnet-02b3dd105b1fb0e33", "subnet-0fff2c4a5a7501ba8", "subnet-0b31198f213e44561"]

}