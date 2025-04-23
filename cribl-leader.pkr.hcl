packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "cribl_auth_token" {
  type      = string
  sensitive = true
}

source "amazon-ebs" "cribl_ubuntu" {
  region = var.region
  vpc_id = "vpc-02ee22e34b2ce299c"
  subnet_id = "subnet-02f5cd8a0a5380267"
  security_group_ids = ["sg-0b47d33df677bf6ca"]
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"] # Canonical
    most_recent = true
  }

  instance_type               = "t2.medium"
  ssh_username                = "ubuntu"
  ami_name                    = "cribl-4.10.1-ubuntu-22.04-{{timestamp}}"
  associate_public_ip_address = true
  tags = {
  Name        = "Cribl Leader AMI"
  Environment = "dev"
  Role        = "cribl-leader"
}
}

build {
  name = "cribl-ubuntu-image"
  sources = [
    "source.amazon-ebs.cribl_ubuntu"
  ]

provisioner "shell" {
  environment_vars = ["CRIBL_AUTH_TOKEN=${var.cribl_auth_token}"]
  script = "install-cribl.sh"
}
}
