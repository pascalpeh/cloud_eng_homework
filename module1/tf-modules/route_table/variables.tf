#-#------- Modules/Route Tables/Variables.tf------#-#

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
