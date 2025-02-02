#-#------- Modules/Security_group/outputs.tf------#-#

output "security_groups_id" {
  value = aws_security_group.this.*.id
}

output "security_groups_list" {
  value = {
      for security_group in aws_security_group.this :
        lookup(security_group.tags, "Name") => security_group.id
  }
  
}

