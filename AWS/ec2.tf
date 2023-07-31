resource "aws_instance" "cloud-migration-web-servers" {
    count = 3
    ami = var.ami
    instance_type = var.instance_type
    #vpc_security_group_ids = [aws_security_group.instance_sg.id]  
    tags = {
        Name = "Web-server-${count.index + 1}"
    }
}