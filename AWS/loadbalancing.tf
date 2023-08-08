resource "aws_lb" "cloud-migration-load-balancer" {
    name = "application-load-balancer"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.lb_sg.id]
    subnets = [for subnet in aws_subnet.public : subnet.id]

    enable_deletion_protection = true
}