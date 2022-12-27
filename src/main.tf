resource "azurerm_resource_group" "rg" {
  name     = "bitwarden-${var.envName}"
  location = "eastus2"
}