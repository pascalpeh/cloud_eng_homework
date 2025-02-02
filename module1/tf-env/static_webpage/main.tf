#-#--------- static_webpage/root/main.tf ---------#-#

# Use AWS Provider
provider "aws" {
  region = var.region
}

# Create VPC
module "vpc" {
  source      = "../../tf-modules/vpc"
  vpc_cidr    = var.vpc_cidr
  vpc_name    = var.vpc_name
  common_tags = var.common_tags
}

# Create subnets
module "subnets" {
  source      = "../../tf-modules/subnet"
  vpc_id      = module.vpc.vpc_id
  subnets     = var.subnets
  common_tags = var.common_tags
}

# Create IGW
module "igw" {
  source      = "../../tf-modules/igw"
  vpc_id      = module.vpc.vpc_id
  igw_name    = var.igw_name
  common_tags = var.common_tags
}

# Create Route Tables
module "route_tables" {
  source       = "../../tf-modules/route_table"
  vpc_id       = module.vpc.vpc_id
  route_tables = var.route_tables
  common_tags  = var.common_tags
}

# Create routes to connect to IGW
module "route_igw" {
  source            = "../../tf-modules/route_igw"
  routes            = var.pub_routes
  route_tables_list = module.route_tables.route_tables_list
  gateway_id        = module.igw.igw_id
}

# Associate public route table to public subnet
module "route_association" {
  source                   = "../../tf-modules/route_association"
  route_table_associations = var.route_table_associations
  subnets_list             = module.subnets.subnets_list
  route_tables_list        = module.route_tables.route_tables_list
}

# Create NACLs (Allow any to any rules first)
module "nacls" {
  source       = "../../tf-modules/nacl"
  vpc_id       = module.vpc.vpc_id
  nacls        = var.nacls
  subnets_list = module.subnets.subnets_list
  common_tags  = var.common_tags
}

# Create security groups for EC2 instances
module "security_groups" {
  source          = "../../tf-modules/security_group"
  security_groups = var.security_groups
  vpc_id          = module.vpc.vpc_id
}

# ## Create user template file for Sonarqube & Jenkins server
# data "template_file" "userdata" {
#   template = file("../../scripts/linux/install_docker-ce_sonarqube_jenkins.tpl")
#   vars = {
#     hostname = var.static_webpage_ec2[0].os_hostname
#   }
# }

## Create EC2 keypair

# Resource to create a SSH private key
resource "tls_private_key" "demo_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Resource to Create EC2 SSH Key Pair
resource "aws_key_pair" "generated_key" {
  key_name   = var.ec2_keypair_name
  public_key = tls_private_key.demo_key.public_key_openssh
}

# Output EC2 key pair
output "ec2_private_key" {
  value     = tls_private_key.demo_key.private_key_pem
  sensitive = true
}

resource "local_file" "ec2_private_key" {
  content  = tls_private_key.demo_key.private_key_pem
  filename = "./ssh_keypair/ec2_private_key.ppk"
}


## Create EC2 instance for static web server
module "static_webpage_ec2" {
  source = "../../tf-modules/ec2"
  ec2_instances = var.static_webpage_ec2
  subnets_list = module.subnets.subnets_list
  security_group_list = module.security_groups.security_groups_list
  common_tags = var.common_tags
  # additional_tags = var.additional_tags				# Optional additional tags such as patch groups, backups
}

# Output public ip address
output "ec2_public_ip" {
  value     = module.static_webpage_ec2.ec2_instances[0].public_ip
}

# Create and attach Elastic IP to an EC2 instance
resource "aws_eip" "ec2" {
  instance = lookup(module.static_webpage_ec2.ec2_instances_list, var.static_webpage_ec2[0].ec2_tag_name)
  domain   = "vpc"
}

output "eip_public_ip" {
  value = aws_eip.ec2.public_ip
}