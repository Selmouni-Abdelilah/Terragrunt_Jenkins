resource "azurerm_app_service_plan" "app_service_plan" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.rg_name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "webapp" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.rg_name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  site_config {
    dotnet_framework_version = "v6.0"
  }

  source_control {
    repo_url           = var.repo_url
    branch             = var.branch
    manual_integration = true
    use_mercurial      = false
  }
}

