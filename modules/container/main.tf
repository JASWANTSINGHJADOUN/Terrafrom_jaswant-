data "azurerm_storage_account" "current" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}


resource "azurerm_storage_container" "example" {
  name                  = var.container_name
  storage_account_id    = data.azurerm_storage_account.current.id
  container_access_type = "container"
}