# Create SNS topic
resource "aws_sns_topic" "sns" {
  name = "my-terraform-project-sns"
}

# Create SNS topic subscription for email
resource "aws_sns_topic_subscription" "sns" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "email"
  endpoint  = "sameer.gcp.jam@gmail.com" # Replace with your email address
}

# Create CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name          = "cpu-utilization-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "30"
  statistic           = "Maximum"
  threshold           = "20"

  # Define dimensions to monitor specific instance
  dimensions = {
    InstanceId = var.instance_id_private
  }

  alarm_description = "This metric monitors my terraform project private server CPU utilization"
  alarm_actions     = [aws_sns_topic.sns.arn]
  ok_actions        = [aws_sns_topic.sns.arn]
  insufficient_data_actions = [aws_sns_topic.sns.arn]

  # Optional: Add tags
  tags = {
    Environment = "production"
  }
}
