#-#--------Modules/subnet/Outputs.tf--------#-#

# Output only the subnet id
output "subnets_id" {
  value = aws_subnet.this.*.id
}

# Output the subnet alias/Name along with the subnet id
output "subnets_list" {
  value = {
    for subnet in aws_subnet.this :
    # format ("%s:%s",lookup(subnet.tags,"alias"),lookup(subnet.tags,"Name")) => subnet.id
    lookup(subnet.tags, "Name") => subnet.id
  }
}

# Outputs all the subnet info
output "subnets" {
  value = aws_subnet.this.*
}
