#-# This Terraform module creates multiple security groups with rules #-#

# How to use this module
Create the following files in the root folder that needs to use this module. See the detailed steps below
root/main.tf
root/variables.tf
root/terraform.tfvars
root/outputs.tf (Optional)


# Step 1: Create a root/main.tf that includes this module and the variables that needs to be created
module "security_groups" {
  source = "../../modules/security_group"
  security_groups = var.security_groups
  vpc_id = module.vpc.vpc_id
}

# Step 2: Create a root/variables.tf and declare the variables, the actual values will be in terraform.tfvars file
variable "security_groups" {
    description = "A list of security groups to be created (Required)"
    type = list
    default = []
}

variable "vpc_id" {
    description = "An existing VPC id (Required)"
    default = {}
}

variable "common_tags" {
    description = "A map of common tags (Optional)"
    type = map
    default = {}
}

variable "additional_tags" {
    description = "A map of additional tags (Optional)"
    type = map
    default = {}
}


# Step 3: Create a root/terraform.tfvars file 
# The following creates 2 security groups with rules inside
# Note: This module will allow all outbound traffic rules
# To allow any ports, set from_port or to_port = 0
# To allow using any port set protocol = -1
security_groups = [
    {
    # Security Group for Bastion hosts
      name = "aws-sg-uat-001-bastion"
      sg_description = "Security Group for Bastion hosts"
      ingress = [
        {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        rule_description = "SSH rule"
        },
        # Allow ICMP ping (To be removed later)
        {
        from_port = "-1"
        to_port = "-1"
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
        rule_description = "Allow ICMP Ping"
        }
      ]
    },
    # Security Group for App nodes
    {
      name = "aws-sg-uat-001-app"
      sg_description = "Security Group for App nodes"
      ingress = [
        {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["10.10.10.0/24"]
        rule_description = "HTTP rule"
        },
        {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["10.10.10.0/24"]
        rule_description = "HTTPS rule"        
        }
      ]
    }
  ]


# Step 4: Create a root/outputs.tf file (Optional)
output "security_groups_list" {
  value = module.security_groups.security_group_list
}

Outputs:

security_groups_list = {
  "aws-sg-uat-001-bastion" = "sg-08120184c2f8ac99f"
  "aws-sg-uat-001-app" = "sg-024c610196409dc3e"
}