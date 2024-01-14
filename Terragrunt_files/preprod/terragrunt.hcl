# Indicate what region to deploy the resources into
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
 terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
 EOF
}

# Backend Bucket
generate "backend" {
  path = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "azurerm" {
      resource_group_name  = "tfstate"
      storage_account_name = "tfstate24429"
      container_name       = "tfstate"
      key                  = "preprod/${path_relative_to_include()}/terraform.tfstate"
  }
}
 EOF
} 