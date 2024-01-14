# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = var.rg_name
  os_type             = "Linux"
  sku_name            = "B1"
}
# Create the web app
resource "azurerm_linux_web_app" "webapp" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.rg_name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  https_only            = true
  site_config { 
    minimum_tls_version = "1.2"
  }
}

#  Deploy code from GitHub repo
resource "azurerm_app_service_source_control" "sourcecontrol" {
  app_id             = azurerm_linux_web_app.webapp.id
  repo_url           = var.repo_url
  branch             = var.branch
  use_manual_integration = true
  use_mercurial      = false
}
