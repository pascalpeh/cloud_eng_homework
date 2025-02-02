#-#--------Modules/VPC/Main.tf------#-#

resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
    # instance_tenancy = default

# Add tags to VPC
    tags = merge (
        {
            "Name" = var.vpc_name
        }, 
        var.common_tags, var.additional_tags
        )
}
