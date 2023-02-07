This module is used to configure an EC2 Instance that is running apache.

```hcl

terraform {

}

provider "aws" {
  region     = "us-east-1"
}

module "terraform-aws-apache-server" {
  source = "./terraform-aws-apache"

  instance_type = "t2.micro"
  ip_address    = "MY-OWN-IP/32"
  vpc_id        = "vpc-000000000"
}


output "public_ip" {
  value = module.terraform-aws-apache-server.public_ip
}

```