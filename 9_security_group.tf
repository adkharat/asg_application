# Creating security group for bastion host
resource "aws_security_group" "bastion_host" {
  name        = var.bastion_security_group_name
  description = "Allow SSH reated By Terraform"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}


resource "aws_security_group" "alb_sg" {
  name        = "alb security group name"
  description = "Allow http, https created By Terraform"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}




# create an AWS EC2 Security Group tailored for private EC2 instances. 
resource "aws_security_group" "private_sg" {
  name        = "allow_web"
  description = "Security group with HTTP, HTTPs & SSH ports open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #This is a list item

  }
  ingress {
    description = "Allow port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #This is a list item

  }
  # Since all internal traffic behinf ALB will be http, no need of https
  # ingress {
  #   description = "Allow port 443"
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"] #This is a list item
  # }

  //ALB target group check health status on port 8080
  ingress {
    description     = "Allow port 8080"
    from_port       = 8080 
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = local.common_tags
}


# Creating a new security group for RDS 
resource "aws_security_group" "rds-sg" {
  depends_on  = [module.vpc]
  name        = var.rds_security_group_name
  description = "rds-sg created By Terraform"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_host.id] # Source to RDS is SG of bastion host # Input from Bastion host SG
    description     = "Allow inbound MySQL traffic from Bastion host in public subnet"
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.private_sg.id] # Disadvantage : entire EC2 instance traffic is allowed, Container level ingress not prersent
    description     = "Allow inbound MySQL traffic from container running on EC2 node present in ASG"
  }

  # ingress {
  #   from_port   = 3306
  #   to_port     = 3306
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"] # Replace "your_ip_address" with your actual IP address
  #   description = "Allow inbound MySQL traffic from your IP address"
  # }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}