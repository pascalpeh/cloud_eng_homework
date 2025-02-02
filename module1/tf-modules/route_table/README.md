#-# This Terraform module creates multiple route tables #-#

# How to use this module
Create the following files in the root folder that needs to use this module. See the detailed steps below
root/main.tf
root/variables.tf
root/terraform.tfvars
root/outputs.tf (Optional)

# Recommendations
1) *Create Route tables using "route_table" module (No routes inside)
2) Create Routes inside Route tables using "route" module
3) Associate routes to route tables using "route_association" module

# Step 1: Create a root/main.tf that includes this module and the variables that needs to be created
module "route_tables" {
  source = "../../modules/route_table"
  vpc_id = module.vpc.vpc_id
  route_tables = var.route_tables
  common_tags = var.common_tags
}

# Step 2: Create a root/variables.tf and declare the variables, the actual values will be in terraform.tfvars file
variable "route_tables" {
    description = "A list of route_tables to be created (Required)"
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
}

variable "additional_tags" {
    description = "A map of additional tags (Optional)"
    type = map
    default = {}
}



# Step 3: Create a root/terraform.tfvars file 
# The following creates 2 route tables (Note that there is no routes inside)
route_tables = [
    {
        Name = "rt-uat-web-lb-pubsub-001"
        Purpose = "Route Table for Public external Web ALB subnets"
    }
    ,
    {
        Name = "rt-uat-web-prisub-001"
        Purpose = "Route Table for Private internal Web subnets"
    }
]


# Step 4: Create a root/outputs.tf file (Optional)
output "route_tables_list" {
    value = module.route_tables.route_tables_list
}

Outputs:
route_tables_list = {
  "rt-uat-web-lb-pubsub-001" = "rtb-0313e1d542f350878"
  "rt-uat-web-prisub-001" = "rtb-05a324ae3c9cafec3"
}