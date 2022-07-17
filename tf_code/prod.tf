variable "whitelist" {
  type = list(string)
}
variable "web_image_id" {
  type = string
}
variable "web_instance_type" {
  type = string
}
variable "web_desired_capacity" {
  type = number
}
variable "web_max_size" {
  type = number
}
variable "web_min_size" {
    type = number
}



provider "aws" {
  profile = "default"
  region  = "us-east-2"


}

resource "aws_s3_bucket" "prod_tf_course" {
  bucket = "tf-course-kevinysugrad2013"
}

resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-2a"
  tags = {
    "Terraform" = "True"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "us-east-2b"
  tags = {
    "Terraform" = "True"
  }
}

resource "aws_default_subnet" "default_az3" {
  availability_zone = "us-east-2c"
  tags = {
    "Terraform" = "True"
  }
}

resource "aws_s3_bucket_acl" "tf_course_bucket_acl" {
  bucket = aws_s3_bucket.prod_tf_course.id
  acl    = "private"
}

resource "aws_security_group" "prod_web" {
  name        = "prod_web"
  description = "Allow standard http and https inbound and outbound"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.whitelist
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.whitelist
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Terraform" = "True"
  }

}

module "web_app" {
  source                 = "C:\\Users\\SLAdmin\\terraform\\tf_code\\modules\\web_app"
  web_image_id           = var.web_image_id
  web_instance_type      = var.web_instance_type
  web_desired_capacity   = var.web_desired_capacity
  web_max_size           = var.web_max_size
  web_min_size           = var.web_min_size
  subnets                = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id, aws_default_subnet.default_az3.id]
  security_groups        = [aws_security_group.prod_web.id]
  web_app                = "prod"
}

