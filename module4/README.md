# Summary for module 4 - Solution Architecting

## Overview of module 4 assignment
- For module 4, we are tasked to design a multi-region, highly available, and scalable architecture on Azure, AWS, or GCP for an e-commerce platform which will be expecting heavy loads and implement features such as automatic scaling, load balancing, and disaster recovery. In addition, we need to provide a cost estimation of services used.


## Architecture Diagram
Please refer to the architecture diagram below

![Module 4 - Architecture Diagram](architecture-diagram/module4-diagram.png)

## Solution Overview
This diagram depicts a multi-region active-passive architecture deployed on AWS across two regions.  Each region hosts an EKS cluster running on Fargate. Region 1 is the primary region, where pods are configured for horizontal pod autoscaling.  Application configuration files and other stateful data reside in AWS EFS and are replicated to the secondary region using AWS DataSync at regular intervals. Container images are pulled from ECR, and application logs are exported to S3, with both ECR and S3 content also replicated to the secondary region.  FluxCD is integrated with the EKS cluster to periodically poll a configured GitHub repository (the source of truth) for changes and automatically deploy them to the EKS cluster.

AWS AuroraDB Global Database is used, with a write/read instance in the primary region and a read-only instance in the secondary region.  This secondary instance is synchronized with the primary and can be promoted to a write instance in the event of a failover. AWS Route 53 private hosted zones are integrated with the Aurora writer/reader endpoints, providing simplified DNS names for the EKS application to use.

AWS Global Accelerator is setup with two endpoint groups: one for the primary region and one for the secondary (failover) region with application load balancer fronting. The traffic dial is set to 100% directing all user traffic to the primary region.

Users authenticate and authorize with the e-commerce platform's web and mobile applications via AWS Cognito. Due to Cognito's lack of built-in cross-region replication, a custom solution is employed. CloudWatch Events and AWS Step Functions periodically export user profiles and groups to a DynamoDB global table in the primary region.  DynamoDB replicates these updates to the secondary region, where they are imported into the standby Cognito user pool.  A third-party identity management platform, such as Okta, is also a potential alternative.

Outbound internet traffic originating from the EKS cluster is routed through AWS Firewall endpoints for inspection.  At the firewall endpoints, the firewall rules is implemented, including whitelisting of approved domain names and Fully Qualified Domain Names (FQDNs). These rules govern whether the traffic is allowed to proceed to its destination on the internet.  Only traffic matching the defined criteria, such as whitelisted domains, is allowed to traverse the firewall and is subsequently routed to the NAT gateway.

Infrastructure as Code (IaC) tools such as Terraform should be utilized for deployment of the setup in the diagram for multi-region so that it allows for version control, automation and repeatability. Furthermore, CI/CD tools, like GitHub Actions and GitOps using Fluxcd are integrated to automate the build, test, and deployment pipelines.


### Components
- AWS Global Accelerator: Provides a single, static entry point (IP addresses or DNS name) for the application. Uses traffic dials to route 100% of traffic to the primary region (active) and 0% to the secondary region (standby).
- AWS Application Load Balancer: The ALB distributes traffic across the EKS pools in each region with the primary region actively serving traffic. The ALB in secondary region is configured in standby mode (routed by AWS Global Accelerator)
- AWS Cognito: AWS Cognito is used for performing user authentication, authorization to the e-commerce platform. 
- AWS EKS (Elastic Kubernetes Service): Application microservices are deployed on AWS EKS with Fargate in both regions. Pods are active with horizontal pod auto-scaling in the primary region, while scaled to zero in the secondary region for cost optimization until failover.
- AWS ECR (Elastic Container Registry): Manages the container images including scanning of software vulnerabilities leveraging the Common Vulnerabilities and Exposures (CVEs) database.
- ElastiCache for Redis: ElastiCache for Redis is deployed in both regions for caching frequently access data to improve application responsiveness
- AWS AuroraDB Global Database: The primary Aurora cluster (writer and reader) resides in the primary region. Read replicas are located in the secondary region which can be promoted as primary during a failover
- AWS Network Firewall: Used for performing egress network traffic inspection to the internet
- AWS EFS: Used for storing of application persistent configuration files
- AWS Datasync: For replication of application configuration files across different region
- AWS S3: For storing of application logs, IaC state files
- AWS SES (Simple Email Service): To allow sending of emails from application
- AWS Shield Standard: AWS Shield Standard provides a basic level of DDoS protection to all AWS customers without any extra cost and it is a valuable first line of defense against common attacks.
- AWS WAF (Web Application Firewall): The WAF is configured with Application load balancers to inspect incoming web requests and helps to protect against common web application attacks such as SQL injection, cross site scripting, etc.
- Monitoring and Alerts: Monitoring dashboard and CloudWatch alarms are configured to monitor for any service failures on the primary region.



## Costs Estimation

The following table shows an estimated cost for both regions per month:

| AWS service  | Description | Cost [USD] |
| ----------- | ------------ | ------------ |
| Elastic Container Registry (ECR) | 10GB per month | $3.80 per month |
| AWS Elastic File System (EFS) | 10GB per month | $9.4 per month |
| AWS DataSync | 10GB per month | $0.26 per month|
| AWS Application Load Balancer | 10GB per month, 10 average number of new connections per second | $43.8 per month|
| AWS Web Application Firewall (WAF) | 1 Web ACL, 10 rules per ACL, 5 managed rule groups per ACL | $52 per month|
| AWS Simple Email Service (SES) | 250000 mail messages sent per month | $26.20 per month |
| AWS ElastiCache | Running on cache.m5.xlarge, 2GB cache data size | $440 per month |
| AWS Simple Storage Service (S3) | S3 standard storage @ 10GB per month | $5.25 per month |
| AWS CloudWatch Logs | 1GB data ingested per month | $1.76 per month |
| AWS Route 53 hosted zone | 2 hosted zones | $1.40 per month |
| AWS Secrets Manager | Number of secrets: 5 | $4.10 per month |
| AWS Cognito | 500 x monthly active users | $13.5 per month |
| AWS Step functions | 500 workflow requests per month |  $6.15 per month | 
| AWS DynamoDB | Data storage size: 10GB | $15.70 per month|
| AWS Transit Gateway | 1 x Transit Gateway attachments, 10GB ingress data processed per month | $102 per month |
| AWS Network Firewall | 1 x Network Firewall endpoint, 100GB data process per month | $580 per month |
| AWS EKS Fargate | 10 pods per day, 0.5 vCPU, GB memory | $225 per month |
| AWS AuroraDB Global Database | Amazon Aurora MySQL-Compatible, 200GB storage | $300 per month |


Total estimated cost: $ 1830.32


## Failover process

Manual Failover:

Automated Failover: 