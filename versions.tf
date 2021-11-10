terraform {
  required_providers {
    dns = {
      source = "hashicorp/dns"
      version = ">= 3.2.1"
    }
  }
  required_version = ">= 0.15"
}