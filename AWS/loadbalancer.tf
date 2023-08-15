resource "aws_lb" "cloud-migration-load-balancer" {
    name = "cloud-migration-load-balancer"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.load-balancer-security-group.id]
    subnets = aws_subnet.cloud-migration-public-subnet.id
    #subnets = [for subnet in aws_subnet.public : subnet.id]

    enable_deletion_protection = true
}

resource "aws_security_group" "load-balancer-security-group" {
    name        = "load-balancer-security-group"
    description = "Terraform load balancer security group"
    vpc_id = aws_vpc.cloud-migration-vpc.id
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]   
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow all outbound traffic
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "cloud-migration-alb-security-group"
    }
}

resource "aws_alb_target_group" "load-balancer-target-group" {
    name = "load-balancer-target-group"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.cloud-migration-vpc.id
    stickiness {
        type = "lb_cookie"
    }
}

resource "aws_alb_listener" "load-balancer-listener" {
    load_balancer_arn = aws_lb.cloud-migration-load-balancer.arn
    port              = "80"
    protocol          = "HTTP"
    default_action {
        target_group_arn = aws_alb_target_group.load-balancer-target-group.arn
        type             = "forward"
    }
}