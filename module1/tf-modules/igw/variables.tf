#-#------------Modules/IGW/variables.tf--------#-#


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

