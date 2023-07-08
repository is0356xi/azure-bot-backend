# リソースグループ
variable "rg_vars" {
  default = {
    name     = "rg-azure-bot-testf46583-dev-backend"
    location = "japaneast"
  }
}

# リソース名のprefix
variable "prefix" {
  default = "azurebot"
}

# Container Apps
variable "container_envs" {}

variable "acr_vars" {
  default = {
    sku           = "Standard"
    admin_enabled = true
  }
}

variable "capp_vars" {
  default = {
    revision_mode = "Single"
    image_name    = "azure-bot-backend:v1.0.0"
    cpu           = 0.50
    memory        = "1Gi"
  }
}