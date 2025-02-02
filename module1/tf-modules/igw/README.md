#-# This Terraform module creates one Internet Gateway (IGW) #-#

# How to use this module
Create the following files in the root folder that needs to use this module. See the detailed steps below
root/main.tf
root/variables.tf
root/terraform.tfvars
root/outputs.tf (Optional)


# Step 1: Create a root/main.tf that includes this module and the variables that needs to be created
module "igw" {
  source = "../../modules/igw"
  vpc_id = module.vpc.vpc_id
  igw_name = var.igw_name
  common_tags = var.common_tags
}

# Step 2: Create a root/variables.tf and declare the variables, the actual values will be in terraform.tfvars file
variable "igw_name" {
    description = "Name of Internet Gateway to be created (Required)"
    default = {}
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
# The following creates one IGW
igw_name = "aws-igw-uat-001"


# Step 4: Create a root/outputs.tf file (Optional)
output "igw_id" {
    value = module.igw.igw_id
}

Outputs:
igw_id = igw-0776e845a5be28352