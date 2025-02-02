#-# This Terraform module creates one VPC #-#

# How to use this module
Create the following files in the root folder that needs to use this module. See the detailed steps below
root/main.tf
root/variables.tf
root/terraform.tfvars
root/outputs.tf (Optional)


# Step 1: Create a root/main.tf that includes this module and the variables that needs to be created
module "vpc" {
  source = "../../modules/vpc"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  common_tags = var.common_tags
}

# Step 2: Create a root/variables.tf and declare the variables, the actual values will be in terraform.tfvars file
variable "vpc_cidr" {
    description = "VPC CIDR range to be created (Required)"
    default = {}
}

variable "vpc_name" {
    description = "VPC name to be created (Required)"
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
# The following creates 1 x VPC CIDR
vpc_cidr = "10.10.10.0/24"
vpc_name = "uat-vpc"
common_tags  = {
    Owner = "Chee Wei"
    BU = "Singtel Cloud"
    Environment = "UAT"
    Description = "Created using Terraform"
}

# Step 4: Create a root/outputs.tf file (Optional)
output "vpc_id" {
    value = module.vpc.vpc_id
}

Outputs:

vpc_id = vpc-0292f9c07964e2911