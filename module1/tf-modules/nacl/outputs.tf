#-#----------Modules/NACL/Outputs.tf-----------#-#


# Output a list of NACL names and their ids
output "nacls_list" {
  value = {
      for nacl in aws_network_acl.this:
        nacl.tags.Name => nacl.id
  }
}
