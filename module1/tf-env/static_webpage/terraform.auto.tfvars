#-#--------- static_webpage/root/terraform.auto.tfvars ---------#-#

# Region for AWS
region = "ap-southeast-1"
# region = "us-east-1"

# VPC CIDR details
vpc_cidr = "192.168.1.0/24"
vpc_name = "vpc-01"
common_tags  = {
    Owner = "pascalpeh"
    Environment = "Sandbox"
    Description = "Created using Terraform"
}

# Subnet details
subnets = [
    # Public web subnets
    {
        cidr_block = "192.168.1.0/28",
        availability_zone = "ap-southeast-1a"
        # availability_zone = "us-east-1a"
        subnet_name = "sub-a-pub-01"
        map_public_ip_on_launch = "true"
    },
    {
        cidr_block = "192.168.1.16/28",
        availability_zone = "ap-southeast-1b"
        # availability_zone = "us-east-1b"
        subnet_name = "sub-b-pub-01"
        map_public_ip_on_launch = "true"
    }

]

# Internet gateway details
igw_name = "igw-01"


# Route Table details
route_tables = [
    {
        Name = "rt-pub-01"
        Purpose = "Route Table for Public subnets"
    }
]

# IGW Routes details
pub_routes = [
    {
        name = "rt-pub-01"
        destination_cidr = "0.0.0.0/0"
    }
]

# Route table associations
route_table_associations = [
    # Route table associations for public subnets
    {
        subnet_name = "sub-a-pub-01"
        route_table_name = "rt-pub-01"       
    },
    {
        subnet_name = "sub-b-pub-01"
        route_table_name = "rt-pub-01"       
    }
]

# NACLs details (Empty NACLs)
nacls = [
# NACLs for public web subnets
{
	nacl_name = "nacl-pub-01"                                             # Required (Tag name for NACL)
	subnet_names = ["sub-a-pub-01","sub-b-pub-01"]                  # Required (Subnet tag name that needs to be applied with NACL rule)
    ingress = [
            {
                protocol   = "-1"
                rule_no    = 100
                action     = "allow"
                cidr_block = "0.0.0.0/0"
                from_port  = "0"
                to_port    = "0"
            }
        ]

        egress = [
            {
                protocol   = "-1"
                rule_no    = 100
                action     = "allow"
                cidr_block = "0.0.0.0/0"
                from_port  = "0"
                to_port    = "0"
            }
        ]
}
]


# Security Group variables
security_groups = [
    {
    # Security Group for Bastion hosts
      name = "sgrp-bastion-001"
      sg_description = "Security Group for Bastion login"
      ingress = [
        {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        rule_description = "SSH rule"
        },
        {
        from_port = 3389
        to_port = 3389
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        rule_description = "RDP rule"
        },
        # Allow ICMP ping (To be removed later)
        {
        from_port = "-1"
        to_port = "-1"
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
        rule_description = "Allow ICMP Ping"
        }
      ]
    },
    # Security Group for Web nodes
    {
      name = "sgrp-web-001"
      sg_description = "Security Group for Web nodes"
      ingress = [
        {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        rule_description = "HTTP inbound Rule"
        },
        {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        rule_description = "HTTPS inbound Rule"
        },
      ]
    }
  ]


ec2_keypair_name = "my_ec2_keypair"

# EC2 variables for Static web server
  static_webpage_ec2 = [ 
    {
        ec2_tag_name = "ec2-static-webpage"    # EC2 Tag Name
        ami = "ami-06dc977f58c8d7857"			# Create from RHEL 9 (HVM)
        instance_type = "t2.micro"
        vpc_security_group_names = ["sgrp-bastion-001","sgrp-web-001"]
        subnet_name = "sub-a-pub-01"
        key_name = "my_ec2_keypair"
        volume_tag_name = "ebs-webserver-os"
        user_data_file_path = "../../scripts/linux/setup_static_webpage.sh"
        root_block_device = {
            # volume_size = "30"
        }
    }
]