#!/bin/bash

# Define color for yellow
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Tailscale service status
echo -e "${YELLOW}Checking Tailscale service status...${NC}"
systemctl status tailscaled

# Check SSH service status
echo -e "${YELLOW}Checking SSH service status...${NC}"
systemctl status ssh

# Check UFW (Uncomplicated Firewall) service status
echo -e "${YELLOW}Checking UFW service status...${NC}"
systemctl status ufw

# Check Samba service status
echo -e "${YELLOW}Checking Samba service status...${NC}"
systemctl status smbd

# Check Apache2 service status
# echo -e "${YELLOW}Checking Apache2 service status...${NC}"
# systemctl status apache2

# Check Docker Status
echo -e "${YELLOW}Checking Docker Status...${NC}"
systemctl status docker
