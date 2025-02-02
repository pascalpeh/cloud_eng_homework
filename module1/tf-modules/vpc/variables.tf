#-#-------Modules/VPC/Variables--------#-##

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