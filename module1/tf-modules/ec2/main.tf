#-# Modules/EC2/Main.tf #-#

resource "aws_instance" "this" {
    count = length (var.ec2_instances) > 0 ? length(var.ec2_instances) : 0
    # Mandatory inputs
    ami = lookup(var.ec2_instances[count.index],"ami")
    subnet_id  = lookup(var.subnets_list,lookup(var.ec2_instances[count.index], "subnet_name"), null)
    key_name = lookup(var.ec2_instances[count.index], "key_name", null)   
    # Extracts the security group ids based on given security group names
    vpc_security_group_ids = flatten([
        for sgn in lookup(var.ec2_instances[count.index],"vpc_security_group_names"): [
            lookup(var.security_group_list,sgn)
        ]
    ])
    # Tags for EC2 instances
    tags = merge(
        {
        Name = lookup(var.ec2_instances[count.index],"ec2_tag_name")
        }, var.common_tags, var.additional_tags
    )
    # Tags for all EBS volumes (root & non-root EBS) attached to EC2. To create separate tags for each EBS, create separate ebs volumes and attach to EC2 instances.
    volume_tags = merge (
        {
        Name = lookup(var.ec2_instances[count.index],"volume_tag_name", null)
        }, var.common_tags, var.additional_tags
    )

    # Optional Root EBS volume attributes (Default values from AMI will be used if this is not provided)
    root_block_device {
        volume_type = lookup(var.ec2_instances[count.index].root_block_device, "volume_type", null)                     # Default is gp2
        volume_size = lookup(var.ec2_instances[count.index].root_block_device, "volume_size", null)                     # Size in Gb (eg. 10, 20)
        iops = lookup(var.ec2_instances[count.index].root_block_device, "iops", null)                                   # Only used with volume type io1
        delete_on_termination = lookup(var.ec2_instances[count.index].root_block_device, "delete_on_termination", null) # Default is true
        encrypted = lookup(var.ec2_instances[count.index].root_block_device, "encrypted", null)                         # Enable Encryption for non-root EBS volume (default is false)
        kms_key_id = lookup(var.ec2_instances[count.index].root_block_device, "kms_key_id", null)                       # Used when encrypted is enabled (eg. arn:aws:kms:ap-southeast-1:123456789012:key/0d3d9ef5-dc7b-4059-a255-18c6da6d4eae)
    }

    # Common optional inputs
    iam_instance_profile = lookup(var.ec2_instances[count.index], "iam_instance_profile", null)
    user_data = fileexists(lookup(var.ec2_instances[count.index], "user_data_file_path", ".empty")) ?  file(lookup(var.ec2_instances[count.index], "user_data_file_path")) : ""     # Specifies the path of the user script (eg. ./apache_installation.sh or apache_installation.sh).
    # Optional inputs  (Rarely used)
    instance_type = lookup(var.ec2_instances[count.index],"instance_type")
    associate_public_ip_address = lookup(var.ec2_instances[count.index],"associate_public_ip_address", null)
    source_dest_check = lookup(var.ec2_instances[count.index],"source_dest_check", null)
    tenancy = lookup(var.ec2_instances[count.index],"tenancy", null)
    cpu_core_count = lookup(var.ec2_instances[count.index],"cpu_core_count", null)
    cpu_threads_per_core  = lookup(var.ec2_instances[count.index],"cpu_threads_per_core", null)

    # Added in ignore changes for volume tags so that any new non-root ebs volumes will not have the same tag name as the root ebs volume 
    # Note: For root ebs volume tags will need to be manually changed next time
    lifecycle {
         ignore_changes = [volume_tags]
    }

    #-# Optional Attributes for EC2 non-root EBS volumes 
    #-# (Note that non-root EBS will have the same tag name as root EBS. To create separate tags for each EBS, create separate ebs volumes and attach to EC2 instances.)
    # ebs_block_device {
    #     device_name = lookup(var.ec2_instances[count.index].ebs_block_device, "device_name", null)                      # The device name for EBS (eg. /dev/sdf to /dev/sdp)
    #     snapshot_id = lookup(var.ec2_instances[count.index].ebs_block_device, "snapshot_id", null)
    #     volume_type = lookup(var.ec2_instances[count.index].ebs_block_device, "volume_type", null)                      # Default is gp2
    #     volume_size = lookup(var.ec2_instances[count.index].ebs_block_device, "iops", null)                             # Size in Gb (eg. 10, 20)
    #     iops = lookup(var.ec2_instances[count.index].ebs_block_device, "iops", null)                                    # Only used with volume type io1
    #     delete_on_termination = lookup(var.ec2_instances[count.index].ebs_block_device, "delete_on_termination", null)  # Default is true
    #     encrypted = lookup(var.ec2_instances[count.index].ebs_block_device, "encrypted", null)                          # Enable Encryption for non-root EBS volume (default is false)
    #     kms_key_id = lookup(var.ec2_instances[count.index].ebs_block_device, "kms_key_id", null)                        # Used when encrypted is enabled (eg. arn:aws:kms:ap-southeast-1:123456789012:key/0d3d9ef5-dc7b-4059-a255-18c6da6d4eae)
    # }

}