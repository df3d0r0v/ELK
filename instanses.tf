data "aws_ami" "amazon-linux-2" {
 owners = ["amazon"]
 most_recent = true

 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

resource "aws_instance" "elk_server" {
  ami           = "${data.aws_ami.amazon-linux-2.id}"
  instance_type = var.instance_type

  tags = {
    Name = "elk_server-${var.tag}"
  }

  key_name = "SSH"

  associate_public_ip_address = "true"

  vpc_security_group_ids = [aws_security_group.ssh.id, aws_security_group.elk_stack_sg.id, aws_security_group.nginx_sg.id]
  subnet_id = aws_subnet.public.id

  provisioner "local-exec" {
    command = "sleep 15; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${self.public_ip},' --private-key /var/lib/jenkins/.ssh/id_rsa ansible/nginx.yaml ansible/elk_stack.yaml"
  }
}

output "ec2_public_ip" {
  value = ["${aws_instance.elk_server.public_ip}"]
}