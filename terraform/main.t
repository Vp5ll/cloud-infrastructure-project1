terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# تحديد المنطقة السحابية
provider "aws" {
  region = "us-east-1"
}

# 1. إنشاء شبكة افتراضية آمنة (VPC)
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "IT-Project-VPC"
  }
}

# 2. إنشاء بوابة إنترنت (Internet Gateway) لتوفير الاتصال الخارجي
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "IT-Project-IGW"
  }
}

# 3. إنشاء جدول التوجيه (Route Table) وتوجيه الحركة للإنترنت
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "IT-Project-Public-RT"
  }
}

# 4. إنشاء Subnet عامة داخل الشبكة
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "IT-Project-Public-Subnet"
  }
}

#ربط الـ Subnet بـ جدول التوجيه
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# 5. إنشاء جدار حماية (Security Group)
resource "aws_security_group" "web_sg" {
  name        = "allow_web_traffic"
  description = "Allow inbound web and monitoring traffic"
  vpc_id      = aws_vpc.main_vpc.id

  # فتح منفذ الويب 8080
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # فتح منفذ شاشة المراقبة Netdata 19999
  ingress {
    from_port   = 19999
    to_port     = 19999
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # فتح منفذ الاتصال الآمن SSH
  ingress {
    from_port   = 22
    to_port     = 22
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

# 6. إنشاء خادم سحابي (EC2 Instance) وتثبيت Docker عليه تلقائياً
resource "aws_instance" "app_server" {
  ami           = "ami-0c7217cdde317cfec" # صورة Ubuntu
  instance_type = "t2.micro"             # فئة مجانية (Free Tier)

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y docker.io docker-compose git
              sudo systemctl start docker
              sudo systemctl enable docker
              EOF

  tags = {
    Name = "IT-Cloud-Infrastructure-Server"
  }
}

# 7. طباعة العنوان المباشر (Public IP) للسيرفر
output "server_public_ip" {
  value       = aws_instance.app_server.public_ip
  description = "العنوان العام للسيرفر السحابي"
}