provider "aws" {
region = "ap-northeast-1"
access_key = "********"
secret_key = "**********"
}

resource "aws_instance" "one" {
ami = "************"
instance_type = "t2.medium"
  key_name        = "ClassforDevops"
  vpc_security_group_ids = [aws_security_group.three.id]
  availability_zone = "ap-northeast-1a"
  user_data       = <<EOF
#!/bin/bash
sudo -i
yum install httpd -y
systemctl start httpd
chkconfig httpd on
echo "hai all this is my swiggy application created by terraform infrastructurte by Akash Biswas server-1" > /var/www/html/index.html
EOF
tags = {
Name = "Goldmine-01"
}
}

resource "aws_instance" "two" {
ami = "**********"
instance_type = "t2.medium"
  key_name        = "ClassforDevops"
  vpc_security_group_ids = [aws_security_group.three.id]
  availability_zone = "ap-northeast-1b"
  user_data       = <<EOF
#!/bin/bash
sudo -i
yum install httpd -y
systemctl start httpd
chkconfig httpd on
echo "hai all this is my swiggy application created by terraform infrastructurte by Akash Biswas server-2" > /var/www/html/index.html
EOF
tags = {
Name = "Goldmine-02"
}
}

resource "aws_elb" "bar" {
  name               = "akash-terraform-elb"
  availability_zones = ["ap-northeast-1a", "ap-northeast-1"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                 = ["${aws_instance.one.id}", "${aws_instance.two.id}"]
  cross_zone_load_balancing = true
  idle_timeout              = 400
  tags = {
    Name = "akash-tf-elb"
  }
}

resource "aws_s3_bucket" "b" {
  bucket = "bucketforterraformcode"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_ebs_volume" "example" {
  availability_zone = "ap-northeast-1a"
  size              = 40

  tags = {
    Name = "akash-ebs"
  }
}
