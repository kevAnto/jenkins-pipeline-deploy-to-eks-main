# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {

  backend "s3" {
    bucket = "remote-state-app"
    key = "eks/terraform.tfstate" 
    region = "us-east-1" 
    #access_key = "xxxxxxxxxxxxxxxx" # the access key created for the user who will be used by terraform
    #secret_key = "xxxxxxxxxxxxxxxx" # the secret key created for the user who will be used by terraform
  }
  /*
  cloud {
    workspaces {
      name = "learn-terraform-eks"
    }
  }
  */

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.2"
    }
  }

  required_version = "~> 1.3"
}