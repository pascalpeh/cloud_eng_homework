# Summary for module 1 - Deployment

## Overview of module 1 assignment
- For module 1, we are tasked to deploy a static HTML website from the following public github
https://github.com/rswiftoffice/SES-Cloud-Homework
- The static HTML website can be hosted in any three major cloud platforms, namely, Azure, Amazon
Web Services (AWS) and Google Cloud Platform (GCP).

## Architecture Diagram
Please refer to the architecture diagram below

![Module 1 - Architecture Diagram](architecture-diagram/module1-diagram.png)


## Pre-requisites for deployment
- Terraform
- AWS account and Access/Secret Keys
- Visual Studio Code (IDE)

## Deployment Environment
- Terraform will be used for provisioning the environment for static HTML website on AWS Cloud. The following resources will be provisioned
- 1 x VPC
- 2 x public subnet (1 in availability zone 1a and 1 in availability zone 1b)
- 2 x security groups (1 for ssh access to VM and 1 for web server access)
- 1 x internet gateway for VM access to public internet
- 1 x RedHat 9 Linux VM with bootscrap scripts to perform setup & installation of Apache webserver and copy the static website contents from public github repository
- 1 x public Elastic IP for accessing the static HTML website

## List of software version used for deployment
- Terraform version v1.7.2
- Visual Studio Code version 1.96.4
- AWS CLI 2.15.16

## Directory structure 

```
├── architecture-diagram    (Overall architecture diagram for module 1)
├── tf-env/static-webpage   (Actual environment for provisioning resources for static webpage)
├── tf-modules              (Terraform parent module for Azure cloud)
├── scripts                 (Bootscrap scripts for VM)
├── execution-logs          (Shows the sample logs for terraform plan, apply and destroy)
```


## Overview of Deployment Steps
- Make sure the software pre-requisites has been downloaded/installed and configured on your local machine
- Configure AWS access/secret keys on your local machine
- Change directory to tf-env\static-webpage
- Run the terraform commands to perform initialization
```
terraform init
```
- Run the terraform commands to check the plan
```
terraform plan
```
- Run the terraform commands to apply and create the resources
```
terraform apply
```
- After the resources has been deployed on AWS cloud, get the public ip address from the terraform output or login to AWS to check the public ip address from the provisioned VM. Open a webpage and paste the public ip. The static webpage should load successfully.