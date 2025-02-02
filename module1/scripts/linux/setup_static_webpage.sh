#!/bin/sh
# Set timezone to Singapore
sudo timedatectl set-timezone Asia/Singapore


# Install Apache Web Server
sudo yum install -y httpd mod_ssl

# Install Git command to clone github repositories
sudo yum install -y git

# Disable firewall daemon
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# Clone public git repository for static webpage hosting
cd ~
git clone https://github.com/rswiftoffice/SES-Cloud-Homework.git
cp -pr SES-Cloud-Homework/* /var/www/html/


# Start Apache web server
sudo systemctl enable httpd
sudo systemctl start httpd

# End