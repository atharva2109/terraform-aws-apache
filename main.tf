locals {
  common_tags = {
    Name = "MyWebServer"
  }
}

data "aws_subnet_ids" "main" {
  vpc_id = data.aws_vpc.main.id
}


data "aws_vpc" "main" {
  id = var.vpc_id
}

data "template_file" "user_data" {
  template = file("${abspath(path.module)}/userdata.yaml")
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Canonical
}

resource "aws_security_group" "main" {
  name        = "Security Group for Apache Server"
  description = "Security Group for Apache Server"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description      = "HTTP Access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.ip_address]
    ipv6_cidr_blocks = []
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "DemoSG-ApacheServer"
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  user_data              = data.template_file.user_data.rendered
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id              = tolist(data.aws_subnet_ids.main.ids)[0]



  tags = local.common_tags
}
