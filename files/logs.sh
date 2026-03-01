#!/bin/bash

cat /var/log/unattended-upgrades/unattended-upgrades.log | grep "No packages"
cat /var/log/unattended-upgrades/unattended-upgrades.log | grep "Packages that will"
