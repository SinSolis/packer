#!/bin/bash
set -e

# Update the OS before first boot
# sudo apt-get update

# Download and install Cribl
curl -fL -o /tmp/cribl.tar.gz https://cdn.cribl.io/dl/4.10.1/cribl-4.10.1-45136dbb-linux-x64.tgz
sudo mkdir -p /opt/cribl
sudo mkdir -p /opt/cribl/local/_system
sudo touch /opt/cribl/local/_system/instance
sudo tar -xzf /tmp/cribl.tar.gz -C /opt/cribl --strip-components=1
sudo rm /tmp/cribl.tar.gz


# Create cribl user and group
sudo groupadd -r cribl
sudo useradd -r -s /bin/false -g cribl cribl


# Initialize cribl as a leader
sudo tee /opt/cribl/local/_system/instance.yml > /dev/null <<EOF
############################################################
#        THIS FILE WAS AUTOMATICALLY SET BY PACKER         #
############################################################

distributed:
  mode: master
  master:
    host: 0.0.0.0
    port: 4200
    forwardToLeaderApi: true
    tls:
      disabled: true
    ipWhitelistRegex: /.&ast;/
    authToken: ${CRIBL_AUTH_TOKEN}
    enabledWorkerRemoteAccess: false
    compression: none
    connectionTimeout: 5000
    writeTimeout: 10000
EOF

# Ensure the cribl user owns the installation directory
sudo chown -R cribl:cribl /opt/cribl

# Configure cribl to run with systemd
sudo /opt/cribl/bin/cribl boot-start enable -m systemd -u cribl

# start and enable the service
#sudo systemctl start cribl
sudo systemctl enable cribl

# Check the status of the service
sudo systemctl status cribl
