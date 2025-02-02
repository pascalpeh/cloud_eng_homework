#-#----------Modules/NACL/Main.tf-----------#-#

# This module creates multiple Network ACLs with ingress/egress rules and assigns to multiple subnets

resource "aws_network_acl" "this" {
    count = length(var.nacls) > 0 ? length(var.nacls) : 0
    vpc_id = var.vpc_id
    subnet_ids = flatten([
      for sbn in lookup(var.nacls[count.index],"subnet_names", []):
      lookup(var.subnets_list, sbn, null)
    ])

    dynamic "ingress" {
        for_each = length(lookup(var.nacls[count.index],"ingress")) == 0 ? [] : lookup(var.nacls[count.index],"ingress")
        content {
            protocol = lookup(ingress.value, "protocol")
            rule_no = lookup(ingress.value, "rule_no")
            action = lookup(ingress.value, "action")
            cidr_block =lookup(ingress.value, "cidr_block")
            from_port = lookup(ingress.value, "from_port")
            to_port = lookup(ingress.value, "to_port")
        }
    }

    dynamic "egress" {
        for_each = length(lookup(var.nacls[count.index],"egress")) == 0 ? [] : lookup(var.nacls[count.index],"egress")
        content {
            protocol = egress.value.protocol
            rule_no = egress.value.rule_no
            action = egress.value.action
            cidr_block = egress.value.cidr_block
            from_port = egress.value.from_port
            to_port = egress.value.to_port
        }
    }

    tags = merge (
        {
            Name = lookup(var.nacls[count.index],"nacl_name", null)
        }, var.common_tags, var.additional_tags
    )
  
}
