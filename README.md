# AWS Private Infrastructure Automation with Ansible

## Overview

This project builds a scalable AWS environment using a bastion host, NAT instance, and Ansible dynamic inventory to manage private EC2 instances without static IPs or manual inventory.

## Key Features

- Bastion host for secure SSH access to private instances
- NAT instance for outbound internet access
- Ansible dynamic inventory (no static IP management)
- Tag-based filtering (`Role=private`)
- SSH ProxyJump for seamless access
- Idempotent Ansible playbooks

## Architecture

![Architecture Diagram](./images/architecture.png)

This diagram shows how Ansible connects to private EC2 instances through a bastion host, while private instances use a NAT instance for outbound internet access. The alternative was to use the  built in AWS function of a NAT gateway, but that was not cost effective for the purposes of this project.

## Problems Solved

### 1. Manual IP Management Did Not Scale

Initially, private instance IPs were manually added into SSH configs and inventory files. This approach does not scale and becomes difficult to maintain as the number of instances grows.This project replaces static inventory with Ansible dynamic inventory, allowing AWS to act as the source of truth. My thought process for this revolved around the question of having to automate processes for 100 devices, or 1000. Surely the answer is NOT to manually input the IPs into the inventory file.

### 2. Bastion Proxy Was Not Being Used

SSH connections to private instances were initially failing because traffic was attempting to connect directly instead of routing through the bastion host. The root cause was that SSH configuration only matched named hosts, while Ansible uses raw private IP addresses. This was resolved by updating the SSH configuration to match the private subnet range and automatically apply ProxyJump.

![SSH Config](./images/ssh-config.png)

### 3. CIDR Overlap Caused Conflicts

A private AWS instance (10.200.50.100) was assigned the same IP address as the Ansible control node in the local environment. This caused incorrect routing and connection failures. The issue was resolved by rebuilding the AWS VPC using a non-overlapping CIDR range (10.0.0.0/16) and allowing AWS to automatically assign private IP addresses.

![CIDRs](./images/CIDR.png)
*Figure: Rebuilt VPC using non-overlapping CIDR range (10.0.0.0/16)*

### 4. Dynamic Inventory Needed Filtering

By default, Ansible dynamic inventory included all running EC2 instances, including the bastion and NAT instances. This was not desired, as only private workload instances should be managed. This was resolved by applying AWS instance tags and filtering on those tags in the inventory configuration.

![AWS Inventory File](./images/aws-inventory.png)

*Figure: Ansible inventory file used to pull private IPs from AWS automatically*

### 5. Group Variables Were Misaligned

Initially, group variables were placed under a generic `aws` group. However, Ansible dynamic inventory created a group named `aws_ec2`, causing the variables to be ignored. This was resolved by aligning the group_vars directory with the actual dynamic inventory group: **group_vars/aws_ec2/main.yml**

![Group Vars](./images/group-vars.png)

## Validation and Results

The environment was validated by generating inventory dynamically from AWS, confirming SSH access through the bastion host, and running Ansible playbooks successfully across all private instances. The final result was a clean, idempotent deployment with all hosts reachable and no manual inventory management required. This is demonstrated by running my [`aws-tailscale.yaml`](./aws-scripts/aws-tailscale.yaml) play twice.

![Pings](./images/pings.png) 

![Instances](./images/instances.png)

*Figure: Using the dynamic inventory file we can see Ansible successfully pings the instances. I've highlighted the IPs on the AWS instances page.*

![Run1](./images/run1.png)

*Figure: First run of installing and authenticating AWS instances to my tailnet.*

![Run2](./images/run2.png)

*Figure: Second run validating idempotence.*

The picture below shows that the devices successfully joined my tailnet. They show as offline because I had terminated the instances before taking a screenshot. If I was to re-create the instances and run the play again the IPs would all be different which wouldn't align with previous screenshots.

![Tailscale](./images/tailscale.png)

## Key Takeaways

- Dynamic inventory eliminates the need for static host management
- AWS tags provide clean and scalable host targeting
- Proper SSH configuration is critical when using a bastion host
- Avoiding CIDR overlap prevents routing conflicts
- Aligning group variables with dynamic inventory groups ensures correct variable application

## Conclusion

This project demonstrates how to build a scalable and maintainable AWS environment using Ansible dynamic inventory, proper network design, and automation best practices. By eliminating manual configuration and relying on AWS as the source of truth, the environment can scale seamlessly while remaining easy to manage.
