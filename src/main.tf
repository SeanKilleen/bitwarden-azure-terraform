data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "bitwarden-${var.envName}"
  location = "eastus2"
}

resource "azurerm_key_vault" "keyvault" {
  name                        = "kv-bitwarden-${var.envName}"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

# TODO: Azure SQL DB that Bitawarden will use (serverless -- I'm OK with cold start issues for cost savings since it'll just show up as a timeout for me once)
resource "azurerm_mssql_server" "sqlserver" {
  name                          = "bitwarden-${var.envName}"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  version                       = "12.0"
  administrator_login           = var.dbSAAccountName
  administrator_login_password  = var.dbSAAccountPassword
  public_network_access_enabled = false
}

resource "azurerm_mssql_database" "sqldb" {
  name                        = "bitwarden-${var.envName}"
  server_id                   = azurerm_mssql_server.sqlserver.id
  license_type                = "BasePrice"
  sku_name                    = "S0"
  auto_pause_delay_in_minutes = 30
  min_capacity                = 0.5

  short_term_retention_policy {
    retention_days = 7
  }
}
# TODO: Container Group to run the instances
# TODO: Figure out how to allow access and reference variables from keyvault
# TODO: Figure out storage account to mount volume for container data
# TODO: Sending email (Azure communication service? Sendgrid?)
