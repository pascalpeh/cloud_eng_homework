#-# This Terraform module creates routes for multiple route tables #-#
# Note: This module is modified to create routes for internet connectivity via IGW. The original module is "route" module

# How to use this module
Create the following files in the root folder that needs to use this module. See the detailed steps below
root/main.tf
root/variables.tf
root/terraform.tfvars

# Recommendations
1) Create Route tables using "route_table" module (No routes inside)
2) *Create Routes inside Route tables using "route" module (Public routes only)
3) Associate routes to route tables using "route_association" module

# Step 1: Create a root/main.tf that includes this module and the variables that needs to be created
module "route_igw" {
  source = "../../modules/route_igw"
  routes = var.pub_routes
  route_tables_list = module.route_tables.route_tables_list
  gateway_id = module.igw.igw_id
}

# Step 2: Create a root/variables.tf and declare the variables, the actual values will be in terraform.tfvars file
variable "pub_routes" {
    description = "A list of routes to be created (Required)"
    type = list
    default = []   
}

variable "route_tables_list" {
    description = "A map of existing route table names and their ids (Required)"
    type = map
    default = {}
}

variable "gateway_id" {
    description = "An existing internet gateway id (Required)"
    default = {}
}




# Step 3: Create a root/terraform.tfvars file 
# The following creates 2 routes to IGW for route table "aws-rt-uat-rt-web-lb-pubsub-001" & "aws-rt-uat-rt-web-pubsub-001"
pub_routes = [
    {
        name = "aws-rt-uat-rt-web-lb-pubsub-001"
        destination_cidr = "0.0.0.0/0"
        # gateway_id = "igw-0562ab3c4b5f13419"  (Not required for this customized module)
    },
    {
        name = "aws-rt-uat-rt-web-pubsub-001"
        destination_cidr = "0.0.0.0/0"
        # gateway_id = "igw-0562ab3c4b5f13419"  (Not required for this customized module)
    }
]