variable "public01_subnet_id" {}
variable "sercurity_group_id" {}

resource "aws_instance" "practice_01" {
  ami               = "ami-068a6cefc24c301d2"
  instance_type     = "t2.micro"
  availability_zone = "ap-northeast-1a"
  vpc_security_group_ids = [
    "${var.sercurity_group_id}"
  ]
  subnet_id  = "${var.public01_subnet_id}"
  key_name   = "${aws_key_pair.practice_01.id}"
  monitoring = true

  tags = {
    Name = "practice_01"
  }
}

#resource "aws_ebs_volume" "practice_01" {
#  availability_zone = "ap-northeast-1a"
#  size              = 10
#
#  tags = {
#    Name = "practice_01"
#  }
#}

#resource "aws_volume_attachment" "ebs" {
#  device_name = "/dev/sdf"
#  volume_id   = "${aws_ebs_volume.practice_01.id}"
#  instance_id = "${aws_instance.practice_01.id}"
#}

resource "aws_eip" "eip" {
  vpc      = true
  instance = "${aws_instance.practice_01.id}"
}

resource "aws_key_pair" "practice_01" {
  key_name   = "practice_01"
  public_key = "${file("./ec2/key_pair/practice_01.pub")}"
}
