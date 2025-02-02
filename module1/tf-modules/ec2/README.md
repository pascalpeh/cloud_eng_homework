#-# This Terraform module creates multiple EC2 instances #-#

# How to use this module
Create the following files in the root folder that needs to use this module. See the steps below for detailed info on what to put inside the root files
root/main.tf
root/variables.tf
root/terraform.tfvars

# Important: Possibly bugs with EBS root and data volume tags
1) To create tags for the ebs volume with EC2 instance using "aws_instance" resource, the "volume_tags" is used which will apply the same tags for all EBS volume (eg. root os and any data ebs volume). However, if additional data ebs volumes are created using the "aws_ebs_volume" resource and attached using "aws_volume_attachment", it will work the first time where root and data ebs volume will have different tag names, however if you run "terraform plan/apply" again, the "volume_tags" will apply the tags to root os and any data ebs volume which makes all ebs volume have the same name.
2) A temporary workaround is to add as "lifecycle" to ignore any changes for "volume_tags" for "aws_instance" resource. However, note that any tags changes for root ebs volumes will need to be performed manually

# Step 1: Create a root/main.tf that includes this module and the variables that needs to be created
# Recommendations: It may be better to create EC2 instances based on their tiers or based on AZs (both has their own benefits)
# Eg. If EC2 provisioning is based on tiers, the input parameters are the same but will be challenging to implement tags for patching schedule
#  Eg. If EC2 provisioning is based on AZs, the input parameters will be different but easier to implement patching schedule
module "web_ec2" {
  source = "../../modules/ec2"
  ec2_instances = var.ec2_instances
  subnets_list = module.subnets.subnets_list
  security_group_list = module.security_groups.security_groups_list
  common_tags = var.common_tags
  additional_tags = var.additional_tags				# Optional additional tags such as patch groups, backups
}


# Step 2: Create a root/variables.tf and declare the variables, the actual values will be in terraform.tfvars file
variable "ec2_instances" {
    description = "A list of EC2 instances to be created (Required)"
    type = list
    default = []
}

variable "subnets_list" {
    description = "A map of existing subnet names and their ids (Required)"
    type = map
    default = {}
}

variable "security_group_list" {
    description = "A map of existing security group names and their ids (Required)"
    type = map
    default = {}
}

variable "common_tags" {
    description = "A map of common tags (Optional)"
    type = map
    default = {}
}

variable "additional_tags" {
    description = "A map of additional tags (Optional)"
    type = map
    default = {}
}

# Step 3: Create a root/terraform.tfvars file 
# Step 3A: # Mandatory attributes for EC2 variables (2 x EC2 instance will be created)
ec2_instances = [ {
    ec2_tag_name = "sc-apache"
	ami = "ami-02079c0159aade6b4"			# Create from RHEL-7.7_HVM-20190923-x86_64-0-Hourly2-GP2
	instance_type = "t2.micro"
	vpc_security_group_names = ["sg1","sg2"]
	subnet_name = "sc-prod-dmz2-1a"
	key_name = "sc-key"
	volume_tag_name = "ebs-test"
	root_block_device = {}
    },
    {
    ec2_tag_name = "sc-nginx"
	ami = "ami-02079c0159aade6b4"			# Create from RHEL-7.7_HVM-20190923-x86_64-0-Hourly2-GP2
	instance_type = "t2.micro"
	vpc_security_group_names = ["sg1"]
	subnet_name = "sc-prod-dmz2-1b"
	key_name = "sc-key"
	volume_tag_name = "ebs-test2"
	root_block_device = {}
    }
]

common_tags = {
    Owner = "cheewei"
    BU = "Singtel Cloud"
}

additional_tags = {
	awsbackup = "yes"
	patchgroup = "ext_web_patch_group"
}

subnet_lists                # Get from subnet modules or provide a list here 
security_group_list         # Get from security group modules or provide a list here 

# Step 3B: # Optional attributes for EC2 variables (To be use inside ec2_instances)
Note: If the optional inputs are used, it must exists for all array of the ec2_instances (eg. if user_data script is provided, it must be provided on all ec2_instances or terraform will throw an error)

   root_block_device {
    }
    iam_instance_profile
    user_data           # File path of installation script
    instance_type
    associate_public_ip_address
    source_dest_check
    tenancy
    cpu_core_count
    cpu_threads_per_core
    #-# Optional Attributes for EC2 non-root EBS volumes 
    ebs_block_device {}

# Step 3C: Mandatory thus optional attributes for EC2 variables (2 x EC2 instance will be created with optional attributes)
ec2_instances = [ {
    ec2_tag_name = "sc-apache"
	ami = "ami-02079c0159aade6b4"			# Create EC2 from RHEL-7.7_HVM-20190923-x86_64-0-Hourly2-GP2
	instance_type = "t2.micro"
	vpc_security_group_names = ["sg1","sg2"]
	subnet_name = "sc-prod-dmz2-1a"
    # associate_public_ip_address = "true"
	# source_dest_check = "true"
	key_name = "sc-key"
	iam_instance_profile ="sc-testcloudwatchrole"
	user_data_file_path = "./install_apache.sh"
	volume_tag_name = "ebs-test"
	root_block_device = {
		volume_type = "gp2"
		volume_size = "11"
		# iops = "" # Only for volume_type io1
		delete_on_termination = "true"
		encrypted  = "true"
		kms_key_id = "arn:aws:kms:ap-southeast-1:231661581212:key/0d3d9ef5-dc7b-4059-a255-18c6da6d4eae"
		}
    },
    {
    ec2_tag_name = "sc-nginx"
	ami = "ami-02079c0159aade6b4"			# Create EC2 from RHEL-7.7_HVM-20190923-x86_64-0-Hourly2-GP2
	instance_type = "t2.micro"
	vpc_security_group_names = ["sg1"]
	subnet_name = "sc-prod-dmz2-1b"
    # associate_public_ip_address = "true"
	# source_dest_check = "true"
	key_name = "sc-key"
	iam_instance_profile ="sc-testcloudwatchrole"
	user_data_file_path = "./install_nginx.sh"
	volume_tag_name = "ebs-test2"
	root_block_device = {}
    }
]


# Example of user_data scripts ./install_nginx.sh (to be placed in the same directory as the root/main.tf)
#!/bin/sh
sudo echo "This file is created using terraform!" > /tmp/terraform-file
sudo yum -y install httpd
# echo "<H1> <font color = blue> Installed Apache using Terraform with user_data scripts! </font></H1>" > /var/www/html/index.html
sudo systemctl enable httpd
sudo systemctl start httpd