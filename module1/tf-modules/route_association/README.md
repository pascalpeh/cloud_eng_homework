#-# This Terraform module creates multiple route table associations #-#


# How to use this module
Create the following files in the root folder that needs to use this module. See the detailed steps below
root/main.tf
root/variables.tf
root/terraform.tfvars

# Recommendations
1) Create Route tables "route_table" module (No routes inside)
2) Create Routes inside Route tables using "route" module (Public routes only)
3) *Associate routes to route tables using "route_association" module

# Step 1: Create a root/main.tf that includes this module and the variables that needs to be created
module "route_association"{
  source = "../../modules/route_association"
  route_table_associations = var.route_table_associations
  subnets_list = module.subnets.subnets_list
  route_tables_list = module.route_tables.route_tables_list
}

# Step 2: Create a root/variables.tf and declare the variables, the actual values will be in terraform.tfvars file
variable "route_table_associations" {
    description = "A list of route table associations to be created (Required)"
    type = list
    default = []
}

variable "subnets_list" {
    description = "A map of existing subnet names and their ids (Required)"
    type = map
    default = {}
}

variable "route_tables_list" {
    description = "A map of existing route table names and their ids (Required)"
    type = map
    default = {}
}

# Step 3: Create a root/terraform.tfvars file 
# The following creates multiple route associations between subnets and route tables
route_table_associations = [
    # Availability zone ap-southeast-1a
    {
        subnet_name = "sub-a-uat-web001"
        route_table_name = "rt-uat-web-prisub-001"       
    },
    {
        subnet_name = "sub-b-uat-web001"
        route_table_name = "rt-uat-web-prisub-001"       
    },
    {
        subnet_name = "sub-a-uat-app001"
        route_table_name = "rt-uat-app-prisub-001"       
    },
    {
        subnet_name = "sub-b-uat-web001"
        route_table_name = "rt-uat-app-prisub-001"       
    }
]