#-#------- Modules/Security_group/main.tf------#-#

resource "aws_security_group" "this" {
  count = length(var.security_groups) > 0 ? length(var.security_groups) : 0

  # name = "tf-${var.security_groups[count.index].name}"    # Add prefix with tf (Note that security group name cannot start with sg)
  name = var.security_groups[count.index].name
  description = var.security_groups[count.index].sg_description
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = lookup(var.security_groups[count.index],"ingress")
    content {
      description = lookup(ingress.value,"rule_description")
      from_port = lookup(ingress.value,"from_port")
      to_port   = lookup(ingress.value,"to_port")
      protocol  = lookup(ingress.value,"protocol")
      cidr_blocks = lookup(ingress.value,"cidr_blocks")
    }
  }

# Allow all outbound rules
  egress {
    description = "Allow all outbound"
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge (
    {
      Name = var.security_groups[count.index].name
    },
    var.common_tags, var.additional_tags
  )
}

