variable "public_01_subnet_id" {}
variable "vpc_id" {}
variable "sg_id" {}
variable "alb_name" {}
variable "certificate_arn" {}
variable "ec2_id" {}


#########################################################
# 新規リソースの作成
#########################################################
resource "aws_lb" "alb" {
  name               = "${var.alb_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.sg_id}"]
  subnets = [
    "${var.public_01_subnet_id}",
    "subnet-09ab43777f9092c9d"
  ]
  enable_deletion_protection = true

  tags = {
    Name = "kujira-sms-${var.alb_name}-alb"
  }
}

resource "aws_lb_target_group" "target_group" {
  name     = "kujira-sms-${var.alb_name}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_listener" "to_https" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.certificate_arn}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target_group.arn}"
  }
}

resource "aws_lb_listener" "redirect_http_to_https" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener_certificate" "certificate" {
  listener_arn    = "${aws_lb_listener.to_https.arn}"
  certificate_arn = "${var.certificate_arn}"
}

resource "aws_lb_target_group_attachment" "alb_attachment" {
  target_group_arn = "${aws_lb_target_group.target_group.arn}"
  target_id        = "${var.ec2_id}"
  port             = 80
}
