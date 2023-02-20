# Set Terraform required providers and versions
terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~>2.2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.4.0"
    }
  }
  required_version = ">= 0.13.7, < 2.0.0"
}

# Configure the vSphere Provider
provider "vsphere" {
}
