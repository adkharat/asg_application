################################################################################
# VPC
################################################################################

# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest#output_database_subnets
# VPC Output Values

# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# VPC CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# VPC Public Subnets
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# VPC Private Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

# Database Subnet
output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}

# VPC NAT gateway Public IP
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

# Internet Gateway Id
output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.igw_id
}


# VPC AZs
output "azs" {
  description = "A list of availability zones spefified as argument to this module"
  value       = module.vpc.azs
}

################################################################################
# BASTION HOST
################################################################################

## ec2_bastion_instance_ids
output "ec2_bastion_instance_ids" {
  description = "Bastion Instance ID"
  value       = module.ec2_bastion_instance.id
}



################################################################################
# RDS
################################################################################

output "rds_endpoint" {
  value = module.rds_instance.db_instance_endpoint
}

output "rds_database_name" {
  value = module.rds_instance.db_instance_name
}

output "rds_instance_username" {
  value     = module.rds_instance.db_instance_username
  sensitive = true
}

# output "secrets_manager" {
#   value = module.secrets_manager
# }

# output "aws_secretsmanager_secrets" {
#   value     = data.aws_secretsmanager_secret_version.secret_credentials.secret_string
#   sensitive = true
# }

# output "rds_password" {
#   value     = jsondecode(data.aws_secretsmanager_secret_version.secret_credentials.secret_string)["db_password"]
#   sensitive = true
# }



################################################################################
# ROUTE 53 HOSTED ZONE
################################################################################

output "HostedZoneObject" {
  value = module.zones.route53_zone_zone_id
}

output "HostedZoneName" {
  value = keys(module.zones.route53_zone_zone_id)[0]
}

output "HostedZoneValue" {
  value = values(module.zones.route53_zone_zone_id)[0]
}

output "HostedZoneId" {
  value = module.zones.route53_zone_zone_id[var.domain_name]
}

################################################################################
# ACM
################################################################################

output "acm_arn" {
  value = module.acm.acm_certificate_arn
}

output "acm_certificate_validation_status" {
  value = module.acm.acm_certificate_status
}

output "acm_certificate_validation_domain" {
  value = module.acm.validation_domains
}


################################################################################
# ASG
################################################################################

output "aws_launch_template" {
  description = "Autoscaling Group "
  value       = aws_launch_template.ec2_asg_template
}

output "autoscaling_group" {
  description = "Autoscaling Group "
  value       = aws_autoscaling_group.asg
}


################################################################################
# ALB
################################################################################

output "target_group_for_frontend" {
  description = "ALB frontend target group arn on 80"
  value       = module.alb.target_groups[var.target_group_frontend]["arn"]
}

output "target_group_for_backtend" {
  description = "ALB backend target group arn on 8080"
  value       = module.alb.target_groups[var.target_group_backend]["arn"]
}

output "target_group_listeners" {
  description = "ALB Target group listeners"
  value       = module.alb.listeners
}

output "target_group_listener_rules" {
  description = "ALB Target group listener_rules"
  value       = module.alb.listener_rules
}

output "aws_lb_https-listener_rule_1" {
  description = "ALB Https listener_rules-1"
  value       = aws_lb_listener_rule.addExchangeRateRule
}

output "aws_lb_https-listener_rule_2" {
  description = "ALB Https listener_rules-1"
  value       = aws_lb_listener_rule.getAmountRule
}

output "aws_lb_https-listener_rule_3" {
  description = "ALB Https listener_rules-1"
  value       = aws_lb_listener_rule.getTotalCountRule
}

output "aws_lb_https-listener_rule_4" {
  description = "ALB Https listener_rules-1"
  value       = aws_lb_listener_rule.landingPage
}