#-#--------- static_webpage/root/outputs.tf ---------#-#

output "subnets_list" {
    value = module.subnets.subnets_list
}
