#-# Modules/EC2/variables.tf #-#

variable "ec2_instances" {
    description = "A list of EC2 instances to be created (Required)"
    type = list
    default = []
}

variable "subnets_list" {
    description = "A map of existing subnet names and their ids (Required)"
    type = map
    default = {}
}

variable "security_group_list" {
    description = "A map of existing security group names and their ids (Required)"
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