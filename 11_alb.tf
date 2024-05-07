# https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest
# https://github.com/terraform-aws-modules/terraform-aws-alb/issues/321
# https://github.com/terraform-aws-modules/terraform-aws-alb/blob/master/docs/patterns.md
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.9.0"

  name                       = var.alb_name
  vpc_id                     = module.vpc.vpc_id
  subnets                    = module.vpc.public_subnets
  security_groups            = [aws_security_group.alb_sg.id]
  enable_deletion_protection = false

  # ALB listen on port
  listeners = {
    ex-http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    ex-https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = module.acm.acm_certificate_arn

      //Default action: If none of below defined rules matched
      action_type = "fixed-response"
      fixed_response = {
        status_code  = "404"
        content_type = "text/plain"
        message_body = "This is a fixed response : Nothing matched"
      }

    }
  }

  target_groups = {
    //Group that handle frontend traffic
    "${var.target_group_frontend}" = {
      name_prefix = "h1"
      protocol    = "HTTP"
      port        = var.target_group_frontend_port //Internally forward to react application on 80
      target_type = "instance"
      # target_id = "id - of EC2 created in ASG"
      create_attachment = false #Will do attachment from ASG resource
    }
    //Group that handle backend traffic
    "${var.target_group_backend}" = {
      name_prefix = "h1"
      protocol    = "HTTP"
      port        = var.target_group_backend_port //Internally forward to spring boot application on 8080
      target_type = "instance"
      # target_id = "id - of EC2 created in ASG"
      create_attachment = false #Will do attachment from ASG resource
    }
  }

  tags = local.common_tags
}

//Based on rule divert the traffic to target group
resource "aws_lb_listener_rule" "addExchangeRateRule" {
  listener_arn = module.alb.listeners["ex-https"]["arn"]
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = module.alb.target_groups[var.target_group_backend]["arn"] //Backend target group
  }

  condition {
    path_pattern {
      values = ["/addExchangeRate", "/addExchangeRate/*"]
    }
  }

  condition {
    host_header {
      values = [var.domain_name]
    }
  }

  tags = {
    name = "addExchangeRateRule-1"
  }
}

//Based on rule divert the traffic to target group
resource "aws_lb_listener_rule" "getTotalCountRule" {
  listener_arn = module.alb.listeners["ex-https"]["arn"]
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = module.alb.target_groups[var.target_group_backend]["arn"] //Backend target group
  }

  condition {
    path_pattern {
      values = ["/getTotalCount", "/getTotalCount/*"]
    }
  }

  condition {
    host_header {
      values = [var.domain_name]
    }
  }
  tags = {
    name = "getTotalCountRule-2"
  }
}

//Based on rule divert the traffic to target group
resource "aws_lb_listener_rule" "getAmountRule" {
  listener_arn = module.alb.listeners["ex-https"]["arn"]
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = module.alb.target_groups[var.target_group_backend]["arn"] //Backend target group
  }

  condition {
    path_pattern {
      values = ["/getAmount", "/getAmount/*"]
    }
  }

  condition {
    host_header {
      values = [var.domain_name]
    }
  }
  tags = {
    name = "getAmountRule-3"
  }
}

//Based on rule divert the traffic to frontend target group
resource "aws_lb_listener_rule" "landingPage" {
  listener_arn = module.alb.listeners["ex-https"]["arn"]
  priority     = 4

  action {
    type             = "forward"
    target_group_arn = module.alb.target_groups[var.target_group_frontend]["arn"] //frontend target group
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  condition {
    host_header {
      values = [var.domain_name]
    }
  }
  tags = {
    name = "landingPage-4"
  }
}