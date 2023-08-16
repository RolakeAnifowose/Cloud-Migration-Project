resource "aws_db_instance" "cloud-migration-relational-database" {
    engine = "mysql"
    identifier = "cloud-migration-relational-database"
    allocated_storage = 20
    engine_version = "5.7"
    instance_class = "db.t3.micro"
    username = "cloudmigrationuser"
    password = "cloudmigrationpassword"
    parameter_group_name = "default.mysql5.7"
    publicly_accessible = "false"
    //subnet_ids = aws_subnet.cloud-migration-private-subnet-1.id
    db_subnet_group_name = aws_db_subnet_group.db_subnet.name
    #vpc_security_group_ids = [aws_security_group.cloud-migration-vpc.id]
    skip_final_snapshot = true
}

resource "aws_db_instance" "rds-standby-database" {
    engine = "mysql"
    identifier = "rds-standby-database"
    allocated_storage = 20
    engine_version = "5.7"
    instance_class = "db.t3.micro"
    username = "standbyinstance"
    password = "standbypassword"
    parameter_group_name = "default.mysql5.7"
    publicly_accessible = "false"
    //subnet_ids = aws_subnet.cloud-migration-private-subnet-2.id
    db_subnet_group_name = aws_db_subnet_group.db_subnet.name
    skip_final_snapshot = true
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

  tags = {
        Name = "rds-security-group"
  }
}

resource "aws_db_subnet_group" "db_subnet" {
    name = "rds-subnet-group"
    subnet_ids = ["${aws_subnet.cloud-migration-private-subnet-1.id}", "${aws_subnet.cloud-migration-private-subnet-2.id}"]
}