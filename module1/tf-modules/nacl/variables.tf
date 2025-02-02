#-#----------Modules/NACL/variables.tf-----------#-#

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