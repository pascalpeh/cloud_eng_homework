#-#--------Modules/VPC/Outputs.tf--------#-#

output "vpc_id" {
  value = aws_vpc.this.id
}