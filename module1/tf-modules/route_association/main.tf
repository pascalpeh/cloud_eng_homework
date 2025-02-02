#-#------- Modules/Route Association/Main.tf------#-#

resource "aws_route_table_association" "this" {
    count = length(var.route_table_associations) > 0 ? length(var.route_table_associations) : 0

    subnet_id = lookup(var.subnets_list, var.route_table_associations[count.index].subnet_name)
    route_table_id = lookup(var.route_tables_list, var.route_table_associations[count.index].route_table_name)
}
