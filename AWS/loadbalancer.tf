resource "aws_lb" "cloud-migration-load-balancer" {
    name = "cloud-migration-load-balancer"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.load-balancer-security-group.id]
    #subnets = aws_subnet.cloud-migration-public-subnet.id
    subnets = ["${aws_subnet.cloud-migration-public-subnet-1.id}", "${aws_subnet.cloud-migration-public-subnet-2.id}"]
    enable_cross_zone_load_balancing = "true" #This enables load balancing across availability zones
    enable_deletion_protection = false
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
    health_check {
        enabled = true
        timeout = 20
        interval = 30
        path = "/"
        port = 80
        healthy_threshold = 3
        unhealthy_threshold = 2
    }
}

resource "aws_alb_target_group_attachment" "attach-ec2-instances" {
    count = length(aws_instance.cloud-migration-web-servers)
    target_group_arn = aws_alb_target_group.load-balancer-target-group.arn
    target_id = aws_instance.cloud-migration-web-servers[count.index].id
    port = 80
}

resource "aws_lb_listener" "http-load-balancer-listener" {
    load_balancer_arn = aws_lb.cloud-migration-load-balancer.arn
    port              = "80"
    protocol          = "HTTP"
    default_action {
        target_group_arn = aws_alb_target_group.load-balancer-target-group.arn
        type = "forward"
    }
}

resource "aws_route" "route_to_lb" {
  route_table_id         = aws_route_table.cloud-migration-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.cloud-migration-internet-gateway.id
}

# resource "aws_alb_listener" "https-load-balancer-listener" {
#     load_balancer_arn = aws_lb.cloud-migration-load-balancer.arn
#     port              = "443"
#     protocol          = "HTTPS"
#     default_action {
#         target_group_arn = aws_alb_target_group.load-balancer-target-group.arn
#         type = "forward"
#     }
# }