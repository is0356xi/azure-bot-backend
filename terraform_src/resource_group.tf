resource "azurerm_resource_group" "rg" {
  name     = var.rg_vars.name
  location = var.rg_vars.location
}