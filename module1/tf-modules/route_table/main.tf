#-#------- Modules/Route Tables/Main.tf------#-#

resource "aws_route_table" "this" {
    # Get a count of all route tables that needs to be created
    count = length(var.route_tables) > 0 ? length(var.route_tables) : 0
    vpc_id = var.vpc_id
    
    tags = merge (
        {
            Name = var.route_tables[count.index].Name
        },
        var.common_tags, var.additional_tags
    )
}