terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.64"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_default_vpc" "default_vpc" {}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Security group for EC2 instance"
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_read_only_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "read_only_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_launch_template" "ec2_launch_template" {
  name_prefix   = "ec2-launch-template-IMDSv1"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = aws_default_subnet.default_az1.id
    security_groups             = [aws_security_group.ec2_sg.id]    
  }


  metadata_options {
    http_tokens               = "optional"  # IMDSv2 is optional
    http_put_response_hop_limit = 1
    http_endpoint             = "enabled"
  }

  user_data = base64encode(<<EOF
#!/bin/bash
sudo yum install docker -y
sudo service docker start
sudo yum install git -y
git clone https://github.com/agusalberca/ssrf-demo-app.git
cd /home/ec2-user/ssrf-demo-app
sudo docker build -t ssrf-demo-app .
sudo docker run -d -p 3000:3000 --name ssrf-demo-app ssrf-demo-app
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "IMDSv1 Test"
    }
  }
}

resource "aws_instance" "ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }
}
