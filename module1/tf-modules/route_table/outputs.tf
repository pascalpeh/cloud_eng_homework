#-#------- Modules/Route Tables/Outputs.tf------#-#

output "route_tables_id" {
  description = "Output all route tables id"
  value = aws_route_table.this.*.id
}

output "route_tables_list" {
    description = "Output a list of route table names and their id"
    value = {
        for rt in aws_route_table.this :
        lookup(rt.tags, "Name") => rt.id
    }
}