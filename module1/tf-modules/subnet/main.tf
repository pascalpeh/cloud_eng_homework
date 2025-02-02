#-#----------Modules/subnet/Main.tf-----------#-#

resource "aws_subnet" "this" {

    # Get the total count of subnets to create
    count = length(var.subnets) > 0 ? length(var.subnets) : 0
    
    # Create the subnets
    vpc_id = var.vpc_id
    cidr_block =  var.subnets[count.index].cidr_block
    availability_zone = lookup(var.subnets[count.index],"availability_zone", null)
    map_public_ip_on_launch = lookup(var.subnets[count.index], "map_public_ip_on_launch", null)
    ipv6_cidr_block = lookup(var.subnets[count.index], "ipv6_cidr_block", null)
    # outpost_arn = lookup(var.subnets[count.index], "outpost_arn", null)
    assign_ipv6_address_on_creation = lookup(var.subnets[count.index], "assign_ipv6_address_on_creation", null)

    tags = merge (
        {
            Name = lookup(var.subnets[count.index], "subnet_name")
            # alias = var.subnets[count.index].alias
        },
        var.common_tags, var.additional_tags
    )
    
    # # Temp fixes to handle Kubernetes tagging subnets issues (Need to fix later)
    # lifecycle {
    #     ignore_changes = [tags]
    #     # ignore_changes = [tags["kubernetes.io/cluster/cw-sb-eks-cluster-01"]]
    # }
}
