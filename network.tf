resource "aws_vpc" "elk_vpc" {
  cidr_block = "10.0.0.0/16"


  tags = {
    Name = "elk_vpc"
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
      Name = "igw"
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
      Name = "main"
  }
}

resource "aws_route_table_association" "crta_public"{
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.public_crt.id}"
}
