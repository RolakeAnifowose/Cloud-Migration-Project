#Cloud Migration Web Servers for hosting web pages
resource "aws_instance" "cloud-migration-web-servers" {
    count = 3
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = aws_subnet.cloud-migration-public-subnet.id
    vpc_security_group_ids = [aws_security_group.ec2-security-group.id]
    associate_public_ip_address = true
    tags = {
        Name = "Web-server-${count.index + 1}"
    }
}

# Security Group Rules
resource "aws_security_group" "ec2-security-group" {
  name = "ec2-security-group"
  vpc_id      = aws_vpc.cloud-migration-vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
