# Summary for module 3 - Containers

## Overview of module 3 assignment
- For module 3, we are tasked to create an application with a webpage that displays the message "You are the xx th visitor,"
where <x> is a counter value obtained from Redis. The counter needs to be incremented with each page visit.


## Architecture Diagram
Please refer to the architecture diagram below

![Module 3 - Architecture Diagram](architecture-diagram/module3-diagram.png)



## Pre-requisites for deployment
- Notepad editor (such as Visual studio code)
- Oracle virtualbox (For running of virtual machines on local machines)
- Vagrant (For quick deployment of pre-baked VMs from public vagrant boxes. Note that vagrant automatically integrates with Oracle Virtualbox for deployment of VMs)
- Docker VM (Running on Oracle VirtualBox using Vagrant scripts)
- Other deployment methods can be used such as using docker desktop


## List of software version used for deployment
- Vagrant version 2.4.3
- Oracle VirtualBox version 7.0
- Vagrant box used -> "gusztavvargadr/docker-linux"
- Docker (Installed and configured in Vagrant box)
- Docker Compose (Installed and configured in Vagrant box)
- Docker images (Pulled from docker hub)
  - redis:latest
  - python:3.9-slim-buster


## Directory structure 

```
├── architecture-diagram    (Overall architecture diagram for module 3)
├── vagrant/VagrantFile     (Contains VagrantFile for deploying docker VM)
├── vagrant/script          (Terraform parent module for Azure cloud)
├── scripts                 (Bootscrap scripts for VM)
├── execution-logs          (Shows the sample logs used for deployment of vagrant scripts)
```


## Overview of Deployment Steps
- Change directory to the folder "module3/vagrant"
- There should be a file named "VagrantFile" and a sub-folder "script/setup-containers.sh"
- Ensure that the pre-requisites software has been installed on your local machine
- Run the following command to validate the Vagrant configuration
```
cd module3/vagrant
vagrant validate
```
- Run the following command to bring up the Vagrant environment. It will automatically setup the docker containers for the webpage
```
vagrant up
```
- After the deployment has completed, the docker VM will be provisioned and 2 containers will be deployed (One python webpage that shows the number of visitors and one redis that keeps track of number of webpage visitor counts)
- Access the webpage using the url http://192.168.2.48:3000. It will show the number of visitor counts
- Clean up the vagrant box using the following commands
```
vagrant destroy
```