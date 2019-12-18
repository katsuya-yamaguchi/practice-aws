variable "env" {}
variable "vpc_cidr_block" {}
variable "subnet_cidr_block_public_a" {}
variable "subnet_cidr_block_public_c" {}
variable "subnet_cidr_block_private_app_a" {}
variable "subnet_cidr_block_private_app_c" {}
variable "subnet_cidr_block_private_db_a" {}
variable "subnet_cidr_block_private_db_c" {}
variable "az_a" {}
variable "az_c" {}

resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.env}"
  }
}

##################################################
# public
##################################################

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "${var.env}"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.subnet_cidr_block_public_a}"
  availability_zone = "${var.az_a}"

  tags = {
    Name = "public_a_${var.env}"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.subnet_cidr_block_public_c}"
  availability_zone = "${var.az_c}"

  tags = {
    Name = "public_c_${var.env}"
  }
}

resource "aws_route_table" "to_internet" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "to_internet"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = "${aws_subnet.public_a.id}"
  route_table_id = "${aws_route_table.to_internet.id}"
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = "${aws_subnet.public_c.id}"
  route_table_id = "${aws_route_table.to_internet.id}"
}

##################################################
# private_app
##################################################
resource "aws_subnet" "private_app_a" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.subnet_cidr_block_private_app_a}"
  availability_zone = "${var.az_a}"

  tags = {
    Name = "private_app_a_${var.env}"
  }
}

resource "aws_subnet" "private_app_c" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.subnet_cidr_block_private_app_c}"
  availability_zone = "${var.az_a}"

  tags = {
    Name = "private_app_c_${var.env}"
  }
}

##################################################
# private_db
##################################################
resource "aws_subnet" "private_db_a" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.subnet_cidr_block_private_db_a}"
  availability_zone = "${var.az_a}"

  tags = {
    Name = "private_db_a_${var.env}"
  }
}

resource "aws_subnet" "private_db_c" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.subnet_cidr_block_private_db_c}"
  availability_zone = "${var.az_c}"

  tags = {
    Name = "private_db_c_${var.env}"
  }
}
