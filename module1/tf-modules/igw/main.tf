#-#----------Modules/IGW/Main.tf-----------#-#

resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_id

  tags = merge (
    {
      Name = var.igw_name
    },
    var.common_tags, var.additional_tags
  )
  
}