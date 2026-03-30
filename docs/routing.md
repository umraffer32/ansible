# Routing Configuration

## Overview

This section describes how route tables were configured so both private subnets could send outbound traffic through the NAT instance while remaining inaccessible from the public internet.

## Route Tables

- Public route table
  - 0.0.0.0/0 → Internet Gateway (IGW)

- Private route table
  - 0.0.0.0/0 → NAT instance

![Private Route Table 1](../images/private-rt1.png)

![Private Route Table 2](../images/private-rt2.png)