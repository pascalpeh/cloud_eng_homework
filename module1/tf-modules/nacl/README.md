#-# This Terraform module creates multiple Network ACLs and attaches to multiple subnets #-#

# How to use this module
Create the following files in the root folder that needs to use this module. See the detailed steps below
root/main.tf
root/variables.tf
root/terraform.tfvars
root/outputs.tf (Optional)


# Step 1: Create a root/main.tf that includes this module and the variables that needs to be created
module "nacls" {
  source = "../../modules/nacl"
  vpc_id = module.vpc.vpc_id
  nacls = var.nacls
  subnets_list = module.subnets.subnets_list
  common_tags = var.common_tags
}


# Step 2: Create a root/variables.tf and declare the variables, the actual values will be in terraform.tfvars file
variable "nacls" {
    description = "A list of NACLs to be created (Required)"
    type = list
    default = []
}

variable "vpc_id" {
    description = "An existing VPC id (Required)"
    default = {}
}

variable "subnets_list" {
    description = "A map of existing subnet names and their ids (Required)"
    type = map
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
# Example 1: The below creates 2 x NACL with 1 x ingress rules & 1 x egress rule each
# Note the following
# nacl_name is the tag name for NACL
# subnet_names is the tag names for subnets (Need to create subnet first) that needs to be applied with the NACLs rule
nacls = [
{
	nacl_name = "nacl-uat-web001"                        # Required (Tag name for NACL)
	subnet_names = ["sub-a-uat-web001"]                  # Required (Subnet tag name that needs to be applied with NACL rule)
	ingress = [
		{
			protocol   = "tcp"
    		rule_no    = 200
   			action     = "allow"
    		cidr_block = "192.168.10.0/24"
    		from_port  = 443
    		to_port    = 443
		}
	]

	egress = [
		{
			protocol   = "tcp"
    		rule_no    = 100
   			action     = "allow"
    		cidr_block = "192.168.10.0/24"
    		from_port  = 443
    		to_port    = 443
		}
	]
}
,
{
	nacl_name = "nacl-uat-app001"                        # Required (Tag name for NACL)
	subnet_names = ["sub-a-uat-app001"]                  # Required (Subnet tag name that needs to be applied with NACL rule)
	ingress = [
		{
			protocol   = "tcp"
    		rule_no    = 100
   			action     = "allow"
    		cidr_block = "10.10.10.0/26"
    		from_port  = 80
    		to_port    = 80
		}
	]

	egress = [
		{
			protocol   = "tcp"
    		rule_no    = 100
   			action     = "allow"
    		cidr_block = "10.10.10.0/26"
    		from_port  = 80
    		to_port    = 80
		}
	]
}
]

# Example 2: The below creates 1 x NACL with empty ingress/egress rules (Allow all)
nacls = [
{
	nacl_name = "nacl-uat-web001"                        # Required (Tag name for NACL)
	subnet_names = ["sub-a-uat-web001"]                  # Required (Subnet tag name that needs to be applied with NACL rule)
    ingress = [											 # Required
            {
                protocol   = "-1"
                rule_no    = 100
                action     = "allow"
                cidr_block = "0.0.0.0/0"
                from_port  = "0"
                to_port    = "0"
            }
        ]

        egress = [											 # Required
            {
                protocol   = "-1"
                rule_no    = 100
                action     = "allow"
                cidr_block = "0.0.0.0/0"
                from_port  = "0"
                to_port    = "0"
            }
        ]
}
]


# Step 4: Create a root/outputs.tf file (Optional)
output "nacls_list" {
  value = module.nacls.nacls_list
}

Outputs:

nacls_list = {
  "nacl-uat-app001" = "acl-0e73032d2ef19ebd0"
  "nacl-uat-web001" = "acl-0871efbb653bcde05"
}