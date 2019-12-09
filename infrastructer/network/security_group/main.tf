variable "vpc_id" {}

resource "aws_security_group" "practice_sg" {
  name        = "practice"
  description = "practice"
  vpc_id      = "${var.vpc_id}"
}

resource "aws_security_group_rule" "inbound_http" {
  type      = "ingress"
  from_port = "80"
  to_port   = "80"
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  security_group_id = "${aws_security_group.practice_sg.id}"
}

resource "aws_security_group_rule" "inbound_https" {
  type      = "ingress"
  from_port = "443"
  to_port   = "443"
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  security_group_id = "${aws_security_group.practice_sg.id}"
}

resource "aws_security_group_rule" "inbound_ssh" {
  type      = "ingress"
  from_port = "22"
  to_port   = "22"
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  security_group_id = "${aws_security_group.practice_sg.id}"
}

resource "aws_security_group_rule" "outbound" {
  type      = "egress"
  from_port = "0"
  to_port   = "0"
  protocol  = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  security_group_id = "${aws_security_group.practice_sg.id}"
}

output "security_group_id" {
  value = "${aws_security_group.practice_sg.id}"
}
