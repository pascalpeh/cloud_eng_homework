#-#--------- static_webpage/root/variables.tf ---------#-#

# AWS Region variable
variable "region" {
  default = {}
}

# VPC variables
variable "vpc_cidr" {
  default = {}
}

# VPC DHCP Options
variable "dhcp_options" {
  type    = list
  default = []
}

variable "vpc_name" {
  default = {}
}

# Common tags
variable "common_tags" {
  type    = map
  default = {}
}


# Subnet variables
variable "subnets" {
  default = {}
}

# Internet Gateway variables
variable "igw_name" {
  default = {}
}

# Route table variables
variable "route_tables" {
  default = []
}

# Route variables (For IGW)
variable "pub_routes" {
  type    = list
  default = []
}

# Route association variables (For all subnets)
variable "route_table_associations" {
  type    = list
  default = []
}

# NACLs variables
variable "nacls" {
  type    = list
  default = []
}

# Security Group variables
variable "security_groups" {
  type    = list
  default = []
}


# EC2  variables for static webpage
variable "static_webpage_ec2" {
  type    = list
  default = []
}

# EC2 Keypair name
variable "ec2_keypair_name" {
  default = {}
}

# # NAT Gateway variables
# variable "nat_gateways" {
#   description = "A list of NAT gateways to be created (Required)"
#   type        = list
#   default     = []
# }

# # NAT Routes variables
# variable "nat_routes" {
#   description = "A list of routes to be created to NAT gateway (Required)"
#   type        = list
#   default     = []
# }

# # Route 53 resolver endpoints variables
# variable "route53_endpoints" {
#   description = "A list of all Route 53 inbound or outbound endpoints to be created (Required)"
#   type        = list
#   default     = []
# }

# # Route 53 outbound resolver rules variables
# variable "route53_resolver_rules" {
#   description = "A list of Route 53 resolver rules to be created (Required)"
#   type        = list
#   default     = []
# }

# # Route 53 resolve rules association variables
# variable "route53_resolver_rule_names" {
#   description = "A list of Route 53 resolver rule names to associate (Required)"
#   type        = list
#   default     = []
# }


# # Managed AD variables
# variable "managed_ad" {
#   description = "Managed Active Directory to be created - Supports only 1 AD (Required)"
#   type        = list
#   default     = []
# }


# # For creating ECS Fargate IAM roles
# variable "iam_roles" {
#   description = "A list of IAM roles to be created (Required)"
#   type        = list
#   default     = []
# }

# # For attaching ECS Fargate IAM policy
# variable "iam_role_policies_attachment" {
#   description = "A list of IAM role policies and attachments to create (Required)"
#   type        = list
#   default     = []
# }

# variable "ecs_task_policy_list" {
#   description = "A map of existing IAM policy names and their ids (Required)"
#   type        = map
#   default     = {}
# }

# # CloudWatch Log Group for Fargate
# variable "cloudwatch_lg" {
#   description = "A list of CloudWatch Log Groups to be created (Required)"
#   type        = list
#   default     = []
# }

# # ECS Cluster variables
# variable "ecs_clusters" {
#   description = "A list of ECS clusters to be created (Required)"
#   type        = list
#   default     = []
# }

# # ECS Task Definition variables
# variable "ecs_task_definitions" {
#   description = "A list of ECS task definitions to be created (Required)"
#   type        = list
#   default     = []
# }

# # ECR Repository variables
# variable "ecr_repos" {
#   description = "A list of ECS Repos (ECR) to be created (Required)"
#   type        = list
#   default     = []
# }

# # Route 53 Private hosted zones
# variable "route53_zones" {
#   description = "A list of Route 53 private hosted zones to be created (Required)"
#   type        = list
#   default     = []
# }

# # Route 53 records
# variable "route53_records" {
#   description = "A list of Route 53 hosted zones to be created (Required)"
#   type        = list
#   default     = []
# }
