output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "subnet_id_public_a" {
  value = "${aws_subnet.public_a.id}"
}
output "subnet_id_public_c" {
  value = "${aws_subnet.public_c.id}"
}
output "subnet_id_private_app_a" {
  value = "${aws_subnet.private_app_a.id}"
}

output "subnet_id_private_app_c" {
  value = "${aws_subnet.private_app_c.id}"
}

output "subnet_id_private_db_a" {
  value = "${aws_subnet.private_db_a.id}"
}

output "subnet_id_private_db_c" {
  value = "${aws_subnet.private_db_c.id}"
}
