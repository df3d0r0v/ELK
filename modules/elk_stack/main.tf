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
    command = "sleep 15; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${self.public_ip},' --private-key /var/lib/jenkins/.ssh/id_rsa ./ansible/nginx.yaml ./ansible/elk_stack.yaml"
  }
}


resource "aws_vpc" "elk_vpc" {
  cidr_block = "10.0.0.0/16"


  tags = {
    Name = "elk_vpc-${var.tag}"
  }
}

resource "aws_subnet" "public" {
  cidr_block = "${cidrsubnet(aws_vpc.elk_vpc.cidr_block, 3, 1)}"
  vpc_id = "${aws_vpc.elk_vpc.id}"
  availability_zone = "eu-central-1a"
}

resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.elk_vpc.id}"

    tags = {
      Name = "igw-${var.tag}"
  }
}

resource "aws_route_table" "public_crt" {
    vpc_id = "${aws_vpc.elk_vpc.id}"
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.igw.id}" 
    }
    
    tags = {
      Name = "main-${var.tag}"
  }
}

resource "aws_route_table_association" "crta_public"{
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.public_crt.id}"
}


resource "aws_security_group" "ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.elk_vpc.id

  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh-${var.tag}"
  }
}

resource "aws_security_group" "elk_stack_sg" {
  name        = "elk_stack_sg"
  description = "Allow elk stack traffic"
  vpc_id      = aws_vpc.elk_vpc.id

  # Elasticksearch
  ingress {
    description = "ingress rules"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 9200
    protocol = "tcp"
    to_port = 9300
  }

  # Kibana
  ingress {
    description = "ingress rules"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 5601
    protocol = "tcp"
    to_port = 5601
  }

  # Logstash
   ingress {
    description = "ingress rules"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 5044
    protocol = "tcp"
    to_port = 5044
  }

  egress {
    description = "egress rules"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }

  tags={
    Name="elk_stack_sg-${var.tag}"
  }
}

resource "aws_security_group" "nginx_sg" {
  name        = "nginx_sg"
  description = "Allow nginx traffic"
  vpc_id      = aws_vpc.elk_vpc.id

   ingress {
    description = "ingress rules"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 80
    protocol = "tcp"
    to_port = 80
  }

  egress {
    description = "egress rules"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  }
  
  tags={
      Name="nginx_sg-${var.tag}"
    }
}