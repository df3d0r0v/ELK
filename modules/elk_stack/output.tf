output "ec2_public_ip" {
  value = ["${aws_instance.elk_server.public_ip}"]
}