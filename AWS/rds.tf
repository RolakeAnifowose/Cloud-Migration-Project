resource "aws_db_instance" "cloud-migration-relational-database" {
    engine = "mysql"
    identifier           = "cloud-migration-relational-database"
    allocated_storage    =  20
    engine_version       = "5.7"
    instance_class       = "db.t3.micro"
    username             = "cloudmigrationuser"
    password             = "cloudmigrationpassword"
    parameter_group_name = "default.mysql5.7"
    #subnet_id = aws_subnet.cloud-migration-private-subnet.id
    #vpc_security_group_ids = [aws_security_group.cloud-migration-vpc.id]

}

resource "aws_security_group" "rds-security-group" {
    name = "rds-security-group"
    vpc_id = aws_vpc.cloud-migration-vpc.id
    ingress {
    from_port   = 3306
    to_port     = 3306
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