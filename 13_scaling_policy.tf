# Policy that is responsible to decrease instance by 1 in ASG and is trigger by alarm
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "kdu_asg_scale_down_policy"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1 #Decrease instance by 1
  cooldown               = 120
  policy_type = "SimpleScaling"
}

# Alarm will trigger the ASG scale_down policy based on the metric CPUUtilization
resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_description   = "Monitors CPU utilization"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  alarm_name          = "kdu_asg_scale_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "5"
  evaluation_periods  = "2"
  period              = "30"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}

# Policy that is responsible to increase instance by 1 in ASG and is trigger by alarm
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "kdu_asg_scale_up_policy"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1 #Increase instance by 1
  cooldown               = 60
  policy_type = "SimpleScaling"
}

# Alarm will trigger the ASG scale_up policy based on the metric CPUUtilization
resource "aws_cloudwatch_metric_alarm" "scale_up" {
  alarm_description   = "Monitors CPU utilization"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  alarm_name          = "kdu_asg_scale_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "25"
  evaluation_periods  = "2"
  period              = "30"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}