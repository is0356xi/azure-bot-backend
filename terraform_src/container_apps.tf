resource "azurerm_container_registry" "acr" {
  name                = "${var.prefix}acr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.acr_vars.sku
  admin_enabled       = var.acr_vars.admin_enabled
}

resource "azurerm_container_app_environment" "capp_env" {
  name                       = "${var.prefix}-capp-env"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws.id
}

resource "azurerm_container_app" "capp" {
  name                         = "${var.prefix}-capp"
  container_app_environment_id = azurerm_container_app_environment.capp_env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = var.capp_vars.revision_mode

  secret {
    name  = "acr-password"
    value = azurerm_container_registry.acr.admin_password
  }

  registry {
    server               = azurerm_container_registry.acr.login_server
    username             = azurerm_container_registry.acr.admin_username
    password_secret_name = "acr-password"
  }

  template {
    container {
      name   = "${var.prefix}-capp-container"
      image  = "${var.prefix}acr.azurecr.io/${var.capp_vars.image_name}"
      cpu    = var.capp_vars.cpu
      memory = var.capp_vars.memory

      dynamic "env" {
        for_each = var.container_envs
        content {
          name  = env.key
          value = env.value
        }
      }

    }
  }

  ingress {
    target_port      = 5000
    external_enabled = true
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}