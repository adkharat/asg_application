# VPC Variables
create_vpc                        = true
vpc_name                          = "asg_vpc_ajay"
vpc_cidr_block                    = "192.168.0.0/16" // Check AWS VPC and Subnet CIDR calculation and allocation. https://medium.com/geekculture/aws-vpc-and-subnet-cidr-calculation-and-allocation-cfbe69050712
vpc_availability_zones            = ["us-east-1a", "us-east-1b"]
vpc_public_subnets                = ["192.168.1.0/24", "192.168.2.0/24"] # WEB
vpc_private_subnets               = ["192.168.3.0/24", "192.168.4.0/24"] # APP
vpc_database_subnets              = ["192.168.5.0/24", "192.168.6.0/24"] # DB
vpc_enable_nat_gateway            = true
vpc_single_nat_gateway            = true
vpc_public_subnets_auto_assign_ip = true
vpc_create_igw                    = true
vpc_database_nat_gateway_route    = true  #Private DB
vpc_database_igw_gateway_route    = false #Public DB
db_name                           = "company"
db_username                       = "root"
db_port                           = "3306"
my_ip_address                     = "202.131.135.153/32" # Replace "your_ip_address" with your actual IP address
kubeconfig                        = "~/.kube/config"
secrets_manager_name              = "RDS_VAULT-4"
domain_name                       = "weekendbuyer.shop" #Purcahsed from hostinger
asg_name                          = "asg_kdu-2024"
rds_db_identifier                 = "database-13"