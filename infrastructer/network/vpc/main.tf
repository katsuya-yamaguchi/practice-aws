resource "aws_vpc" "practice" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "practice"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.practice.id}"

  tags = {
    Name = "practice"
  }
}

resource "aws_subnet" "practice_public01" {
  vpc_id            = "${aws_vpc.practice.id}"
  cidr_block        = "10.0.10.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "practice_public01"
  }
}

resource "aws_route_table" "to_internet" {
  vpc_id = "${aws_vpc.practice.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "to_internet"
  }
}

resource "aws_route_table_association" "practice_public01" {
  subnet_id      = "${aws_subnet.practice_public01.id}"
  route_table_id = "${aws_route_table.to_internet.id}"
}

output "vpc_id" {
  value = "${aws_vpc.practice.id}"
}

output "public01_subnet_id" {
  value = "${aws_subnet.practice_public01.id}"
}
