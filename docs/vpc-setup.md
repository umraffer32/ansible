# VPC Setup

## Overview

This section describes how the AWS VPC was designed to support private EC2 instances, a bastion host, and a NAT instance while avoiding CIDR overlap with the local environment.

## VPC Configuration

- CIDR Block: 10.0.0.0/16
- Region: us-west-2

This CIDR range was chosen to avoid overlap with the local lab environment, which previously caused routing conflicts.

## Subnets

- Public Subnet (us-west-2a) 10.0.0.0/20
  - Bastion host
  - NAT instance

- Private Subnet 1 (us-west-2a) 10.0.128.0/20
  - Private EC2 instances

- Private Subnet 2 (us-west-2a) 10.0.144.0/20
  - Private EC2 instances

## Design Rationale

The public subnet was used for the bastion and NAT instances because both require internet-facing access. The private subnets were used for workload instances so they could remain inaccessible from the public internet while still reaching outbound services through the NAT instance.  

## VPC Resource Map

The VPC layout and CIDR redesign are shown in the main README:

[View Architecture](../README.md#CIDR.png)
