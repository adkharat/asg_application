resource "aws_launch_template" "ec2_asg_template" {
  name_prefix            = "kdu-asg-template"
  image_id               = "ami-07caf09b362be10b8" # AWS-AMI Need to change based on AWS Region 
  instance_type          = "t2.medium"
  key_name               = var.ec2_key_name
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  # Bootstrap script for Amazon Linux
  user_data = filebase64("docker_server_bootstrap.sh")
}


resource "aws_autoscaling_group" "asg" {
  name = var.asg_name

  max_size         = 3
  desired_capacity = 2
  min_size         = 1

  health_check_grace_period = 15
  health_check_type         = "EC2"
  force_delete              = true
  vpc_zone_identifier       = module.vpc.public_subnets                                                                                               #decides whether EC2 will be in public or Private
  target_group_arns         = [module.alb.target_groups[var.target_group_frontend]["arn"], module.alb.target_groups[var.target_group_backend]["arn"]] #Will add instances into ALB target group

  launch_template {
    id      = aws_launch_template.ec2_asg_template.id
    version = aws_launch_template.ec2_asg_template.latest_version
  }

  tag {
    key                 = "kdu"
    value               = "2024"
    propagate_at_launch = true
  }
}


