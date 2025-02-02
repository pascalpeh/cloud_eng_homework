#-#----------Modules/subnet/variables.tf-----------#-#

variable "vpc_id" {
  description = "An existing VPC id (Required)"
  default     = {}
}

variable "subnets" {
  description = "A list of subnets to be created (Required)"
  type        = list
  default     = []
}

variable "common_tags" {
  description = "A map of common tags (Optional)"
  type        = map
  default     = {}
}

variable "additional_tags" {
  description = "A map of additional tags (Optional)"
  type        = map
  default     = {}
}
