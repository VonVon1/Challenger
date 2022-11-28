locals {
  vpc_id           = aws_vpc.prod_vpc.id
  subnet_id        = aws_subnet.prod_subnet.id
  ssh_user         = "ubuntu"
  key_name         = "aws.matheus.virginia"
  private_key_path = "/home/Von/.ssh/aws.matheus.virginia.pem"
}

resource "aws_vpc" "prod_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "prod"
  }
}

resource "aws_subnet" "prod_subnet" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "prod"
  }
}

resource "aws_security_group" "sg_nginx" {
  name   = "nginx"
  vpc_id = aws_vpc.prod_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name = "internet_gateway"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.prod_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id 
  }

}

resource "aws_route_table_association" "route_table_association" {
  subnet_id = aws_subnet.prod_subnet.id
  route_table_id = aws_route_table.route_table.id
  
}

resource "aws_instance" "ec2_prod" {
  ami                         = "ami-0ee23bfc74a881de5" # us-east-1
  subnet_id                   = aws_subnet.prod_subnet.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.sg_nginx.id]
  key_name                    = local.key_name 

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = aws_instance.ec2_prod.public_ip
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${aws_instance.ec2_prod.public_ip}, --private-key ${local.private_key_path} ansible.yaml"
  }

}

output "instance_ip" {
  value = aws_instance.ec2_prod.id
}