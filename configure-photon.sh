#!/bin/bash

# Set the desired hostname
HOSTNAME="hostname"

# Set the desired static IP address
IP="1.2.3.4"
NETMASK="24"
GATEWAY="1.2.3.1"
DNS="1.1.1.1"

# Change DHCP setting
sed -i 's/DHCP=yes/DHCP=no/' /etc/systemd/network/99-dhcp-en.network

# Change the hostname
echo "$HOSTNAME" > /etc/hostname
hostnamectl set-hostname "$HOSTNAME"

# Configure static IP address
cat << EOF > /etc/systemd/network/10-static-en.network
[Match]
Name=eth0

[Network]
Address=$IP/$NETMASK
Gateway=$GATEWAY
DNS=$DNS
EOF

chmod 644 /etc/systemd/network/10-static-en.network

# Restart the network service
systemctl restart systemd-networkd

# Enable and start Docker service
systemctl enable docker
systemctl start docker

# Removing password expiry
chage -m 0 root

reboot