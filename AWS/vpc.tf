#Cloud Migration Project
provider "aws" {
  region = "us-east-1"
}

#VPC
resource "aws_vpc" "cloud-migration-vpc" {
  cidr_block = "10.0.0.0/16"  
  tags = {
    Name = "Cloud-Migration-VPC"
  }
  enable_dns_hostnames = true
  enable_dns_support   = true
}

#Internet Gateway
resource "aws_internet_gateway" "cloud-migration-internet-gateway" {
   vpc_id = aws_vpc.cloud-migration-vpc.id
   tags = {
    Name = "Cloud-Migration-Internet-Gateway"
   }
}

#Public Subnet
resource "aws_subnet" "cloud-migration-public-subnet" {
  cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.cloud-migration-vpc.id
  availability_zone = "us-east-1a"
  tags = {
   Name = "Cloud-Migration-Public-Subnet"
 }
}

#Private Subnet
resource "aws_subnet" "cloud-migration-private-subnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.cloud-migration-vpc.id
  availability_zone = "us-east-1a"
  tags = {
   Name = "Cloud-Migration-Private-Subnet"
 }
}

#Route Table to enable Internet traffic
resource "aws_route_table" "cloud-migration-route-table" {
  vpc_id = aws_vpc.cloud-migration-vpc.id
  route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.cloud-migration-internet-gateway.id
  }
  tags = {
    Name = "Cloud-Migration-Route-Table"
  }
}

#Route
resource "aws_route" "public-internet-route" {
  route_table_id         = aws_route_table.cloud-migration-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.cloud-migration-internet-gateway.id
}

#Associate Public Subnet to the User-Created Route Table
resource "aws_route_table_association" "public-subnet-association-to-route-table" {
  subnet_id      = aws_subnet.cloud-migration-public-subnet.id
  route_table_id = aws_route_table.cloud-migration-route-table.id
}

#Network ACL to act as a firewall for controlling traffic in and out of a subnet
resource "aws_network_acl" "cloud-migration-network-acl" {
  vpc_id = aws_vpc.cloud-migration-vpc.id
  subnet_ids = [aws_subnet.cloud-migration-public-subnet.id]

  # Inbound rules
  ingress {
    rule_no  = 100
    protocol     = "tcp"
    action       = "allow"
    cidr_block   = "0.0.0.0/0"
    from_port    = 80
    to_port      = 80
  }

  # Outbound rules
  egress {
    rule_no  = 100
    protocol     = "tcp"
    action       = "allow"
    cidr_block   = "0.0.0.0/0"
    from_port    = 443
    to_port      = 443
  }

  tags = {
    Name = "Cloud-Migration-Network-ACL"
  }
}
