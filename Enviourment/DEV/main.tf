terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.35.0"
    }
  }
}

provider "azurerm" {
    features {}
    subscription_id = "cb9555ea-8e50-4461-a61b-e3667756c521"
}


module "resource_group" {
  source                   = "../../modules/RG"
  resource_group_name      = var.resource_group_name
  resource_group_location  = var.location

}

module "virtual_network" {
  depends_on               = [ module.resource_group ]
  source                   = "../../modules/VNET"
  virtual_network_name     = var.virtual_network_name
  resource_group_name      = var.resource_group_name
  resource_group_location  = var.location
  
}
module "subnet" {
  depends_on = [ module.resource_group, module.virtual_network ]
  source                   = "../../modules/SUBNET"
  virtual_network_name     = var.virtual_network_name
  resource_group_name      = var.resource_group_name
  subnet_name              = var.subnet_name
}

module "storage_account" {
  depends_on               = [ module.resource_group ]
  source                   = "../../modules/storage-account"
  storage_account_name     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  resource_group_location = var.location
}

module "container" {
  depends_on = [ module.storage_account ]
  source                   = "../../modules/container"
  storage_account_name     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  container_name           = var.container_name
}

module "vm" {
  depends_on               = [ module.subnet, module.container ]
  source                   = "../../modules/VM"
  vm_nic                   = var.network_interface_name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  vm_name                  = var.vm_name
  vm_size                  = var.vm_size
  admin_username           = var.admin_username
  admin_password           = var.admin_password
  os_disk_name             = var.os_disk_name
  image_publisher          = var.image_publisher
  image_offer              = var.image_offer
  image_sku                = var.image_sku
  virtual_network_name     = var.virtual_network_name
  azurerm_subnet           = var.subnet_name
}

