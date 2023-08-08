# resource "aws_cloudwatch_dashboard" "cloud-migration-cloudwatch-dashboard" {
#   dashboard_name = "cloudwatch-dashboard"
# }

resource "aws_cloudwatch_metric_alarm" "ec2-metrics" {
  alarm_name                = "ec2-CPU-metric"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 30
  alarm_description         = "Metric for CPU utilisation. Alarm when CPU utilisation exceeds 30%"
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "rds-metrics" {
  alarm_name                = "rds-CPU-metric"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/RDS"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 30
  alarm_description         = "Metric for CPU utilisation. Alarm when CPU utilisation exceeds 30%"
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.cloud-migration-relational-database.identifier
  }
  insufficient_data_actions = []
}