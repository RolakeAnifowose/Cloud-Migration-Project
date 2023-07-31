resource "aws_db_instance" "cloud-migration-relational-database" {
    engine = "mysql"
    identifier           = "cloud-migration-relational-database"
    allocated_storage    =  20
    engine_version       = "5.7"
    instance_class       = "db.t2.micro"
    username             = "cloudmigrationuser"
    password             = "cloudmigrationpassword"
    parameter_group_name = "default.mysql5.7"
    #vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

resource "aws_security_group" "rds-security-group" {
    name = "rds-security-group"
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