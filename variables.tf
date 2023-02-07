variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ip_address" {
  type        = string
  description = "Provide your IP Address in the form of 165.225.120.220/32"
}

variable "vpc_id" {
  type = string
}

