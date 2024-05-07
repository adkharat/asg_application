################################################################################
# ENVIRONMENT
################################################################################

# Environment Variable
variable "aws_region" {
  description = "Region for AWS"
  type        = string
  default     = "us-east-1"
}


# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "ASG"
}

# Business Division
variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = "Ajay"
}

# Path to config file for the Kubernetes provider as variable
variable "kubeconfig" {
  description = "kubectl_config_path"
  type        = string
  # Load the kubeconfig from your home directory (default location for Docker Desktop Kubernetes)
  default = "~/.kube/config"
}

################################################################################
# VPC
################################################################################

variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

# VPC Name
variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "asg_vpc_ajay"
}

# VPC CIDR Block
variable "vpc_cidr_block" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.0.0.0/16"
}

# VPC Availability Zones
variable "vpc_availability_zones" {
  description = "VPC Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# VPC Public Subnets - WEB
variable "vpc_public_subnets" {
  description = "VPC Public Subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# VPC Private Subnets - APP
variable "vpc_private_subnets" {
  description = "VPC Private Subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

# VPC Database Subnets - DB
variable "vpc_database_subnets" {
  description = "VPC Database Subnets"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

# VPC Create Database Subnet Group (True / False)
variable "vpc_create_database_subnet_group" {
  description = "VPC Create Database Subnet Group"
  type        = bool
  default     = true
}

# VPC Create Database Subnet Route Table (True or False)
variable "vpc_create_database_subnet_route_table" {
  description = "VPC Create Database Subnet Route Table"
  type        = bool
  default     = true
}

# VPC Database Subnet can communicate to internet (True or False)
variable "vpc_database_nat_gateway_route" {
  description = "Database Subnet can communicate to internet"
  type        = bool
  default     = true
}

# VPC Database Subnet can receive communicate from internet (True or False)
variable "vpc_database_igw_gateway_route" {
  description = "Database Subnet can receive communicate from internet"
  type        = bool
  default     = false
}


# VPC Enable NAT Gateway (True or False) 
variable "vpc_enable_nat_gateway" {
  description = "Enable NAT Gateways for Private Subnets Outbound Communication"
  type        = bool
  default     = true
}

variable "vpc_public_subnets_auto_assign_ip" {
  description = "Auto assign public IP to public subnet"
  type        = bool
  default     = true
}

# VPC Single NAT Gateway (True or False)
variable "vpc_single_nat_gateway" {
  description = "Enable only single NAT Gateway in one Availability Zone to save costs during our demos"
  type        = bool
  default     = true
}

variable "vpc_create_igw" {
  description = "Controls if an Internet Gateway is created for public subnets and the related routes that connect them"
  type        = bool
  default     = true
}

# Key for EC2s
variable "ec2_key_name" {
  description = "Key attached to EC2 like Bastion host, Jenkins server, etc..."
  type        = string
  default     = "tf-key-pair-kdu"
}



################################################################################
# DATABSE
################################################################################

# DB Security group name
variable "rds_security_group_name" {
  description = "rds_security_group_name"
  type        = string
  default     = "rds_security_group_name"
}

# Bastion host Security group name
variable "bastion_security_group_name" {
  description = "bastion_security_group_name"
  type        = string
  default     = "bastion_host_security_group_name"
}

variable "db_name" {
  type        = string
  description = "The name of the database"
  default     = "company"
}

variable "db_username" {
  type        = string
  description = "The username for database access"
  default     = "root"
}

variable "db_port" {
  type        = string
  description = "The port for database access"
  default     = "3306"
}


variable "secrets_manager_name" {
  type        = string
  description = "secrets_manager vault name"
  default     = "RDS_VAULT-4"
}

variable "rds_subnet_group_name" {
  type        = string
  description = "rds_subnet_group name"
  default     = "rds_subnet_group_for_kdu"
}

variable "rds_db_identifier" {
  type        = string
  description = "rds_db_identifier name"
  default     = "database-13"
}


################################################################################
# SECURITY GROUP
################################################################################

# Replace "your_ip_address" with your actual IP address
variable "my_ip_address" {
  description = "Your allowed IP address"
  type        = string
  default     = "202.131.135.68/32" # Replace "your_ip_address" with your actual IP address
}



################################################################################
# ROUTE 53
################################################################################

variable "domain_name" {
  description = "The domain name for which you want to create resources."
  default     = "weekendbuyer.shop"
}




################################################################################
# ALB
################################################################################

# ALB Name
variable "alb_name" {
  description = "alb_name"
  type        = string
  default     = "alb-for-asg-kdu" # Replace "your_ip_address" with your actual IP address
}

variable "target_group_frontend" {
  description = "the key of the target group to which traffic should be forwarded : port 80"
  default     = "front-end-target-group"
}

variable "target_group_frontend_port" {
  description = "Internally forwarded : port 8080"
  default     = 80
}

variable "target_group_backend" {
  description = "the key of the target group to which traffic should be forwarded : port 8080"
  default     = "back-end-target-group"
}

variable "target_group_backend_port" {
  description = "Internally forwarded : port 8080"
  default     = 8080
}

################################################################################
# ASG
################################################################################
variable "asg_name" {
  description = "Name of autoscaling group"
  default     = "asg_kdu-2024"
}