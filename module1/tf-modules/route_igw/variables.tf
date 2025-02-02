#-#----------Modules/routes_igw/variables.tf-----------#-#

variable "routes" {
    description = "A list of routes to be created (Required)"
    type = list
    default = []   
}

variable "route_tables_list" {
    description = "A map of existing route table names and their ids (Required)"
    type = map
    default = {}
}

variable "gateway_id" {
    description = "An existing internet gateway id (Required)"
    default = {}
}
