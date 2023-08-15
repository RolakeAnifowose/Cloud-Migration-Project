resource "aws_launch_template" "autoscaling-launch-template" {
    name = "ec2-autoscaling-launch-template"
    image_id = var.ami
    instance_type = var.instance_type
    security_groups = [aws_security_group.ec2-security-group.id]
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "ec2-autoscaling-group" {
    name = "ec2-autoscaling-group"
    min_size = 2
    max_size = 3
    desired_capacity = 3
    health_check_type = "EC2"
    health_check_grace_period = 300 
    termination_policies = ["OldestInstance"]
    launch_template {
        id = aws_launch_template.ec2-autoscaling-launch-template.id
        version = "$Latest"
    }
    //vpc_zone_identifier = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]  # Replace with your subnet IDs
}

resource "aws_autoscaling_policy" "simple_scaling" {
    name = "simple-scaling-policy"
    scaling_adjustment = 3 #Number of instances to scale to
    policy_type = "SimpleScaling"
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = aws_autoscaling_group.ec2-autoscaling-group.name
}