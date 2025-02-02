#-#----------Modules/routes_igw/main.tf-----------#-#

resource "aws_route" "this" {
  count = length (var.routes) > 0 ? length(var.routes) : 0
  route_table_id = lookup(var.route_tables_list,var.routes[count.index].name)
  # route_table_id = var.route_tables_list[lookup(var.routes[count.index],"name")]
  destination_cidr_block = var.routes[count.index].destination_cidr

  # Harcoded to accept only gateway_id
  gateway_id = var.gateway_id
}