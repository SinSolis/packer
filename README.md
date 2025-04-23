# packer

# generate auth token

head /dev/urandom | LC_ALL=C tr -dc A-Za-z0-9 | head -c32 | cut -c 1-



# Remove this file to ensure we don't end up with duplicate GUIDs

rm /opt/cribl/local/cribl/auth/676f6174733432.dat

https://docs.cribl.io/stream/deploy-distributed#workers-guid-on-host-image-or-vm



# health endpoint

https://docs.cribl.io/stream/deploy-distributed#auto-scale-workers-and-load-balance-incoming-data 


# systemd and me 

sudo /opt/cribl/bin/cribl boot-start enable -m systemd -u cribl

# packer build command
packer build -var "cribl_auth_token=$CRIBL_AUTH_TOKEN" cribl-worker.pkr.hcl