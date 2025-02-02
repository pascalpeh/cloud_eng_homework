#-# This Terraform module creates multiple subnets #-#

# How to use this module
Create the following files in the root folder that needs to use this module. See the detailed steps below
root/main.tf
root/variables.tf
root/terraform.tfvars
root/outputs.tf (Optional)


# Step 1: Create a root/main.tf that includes this module and the variables that needs to be created
module "subnets" {
   source = "../../modules/subnet"
   vpc_id = module.vpc.vpc_id
   subnets = var.subnets
   common_tags = var.common_tags
}

# Step 2: Create a root/variables.tf and declare the variables, the actual values will be in terraform.tfvars file
variable "vpc_id" {
    description = "An existing VPC id (Required)"
    default = {}  
}

variable "subnets" { 
    description = "A list of subnets to be created (Required)"
    type = list
    default = []
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
# The following creates multiple subnets
subnets = [
    {
        cidr_block = "10.10.10.0/27",
        availability_zone = "ap-southeast-1a"
        subnet_name = "sub-a-uat-web001"
        map_public_ip_on_launch = "false"
    },
    {
        cidr_block = "10.10.10.32/27",
        availability_zone = "ap-southeast-1b"
        subnet_name = "sub-b-uat-web001"
        map_public_ip_on_launch = "false"
    },
    {
        cidr_block = "10.10.10.64/27",
        availability_zone = "ap-southeast-1b"
        subnet_name = "sub-b-uat-app001"
        map_public_ip_on_launch = "false"
    },
    {
        cidr_block = "10.10.10.96/27",
        availability_zone = "ap-southeast-1b"
        subnet_name = "sub-b-uat-app001"
        map_public_ip_on_launch = "false"
    }
]
common_tags  = {
    Owner = "Chee Wei"
    BU = "Singtel Cloud"
    Environment = "UAT"
    Description = "Created using Terraform"
}


# Step 4: Create a root/outputs.tf file (Optional)
output "subnets_list" {
    value = module.subnets.subnets_list
}

Outputs:

subnets_list = {
  "sub-a-uat-web001" = "subnet-096a1327f37e1f484"
  "sub-b-uat-web001" = "subnet-0b576b7a3432a1986"
  "sub-a-uat-app001" = "subnet-0a31f737af37e6b4f3"
  "sub-b-uat-app001" = "subnet-0b4362a13432a1a34"
}