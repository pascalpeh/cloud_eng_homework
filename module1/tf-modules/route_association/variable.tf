#-#------- Modules/Route Association/Variables.tf------#-#

variable "route_table_associations" {
    description = "A list of route table associates to be created (Required)"
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
