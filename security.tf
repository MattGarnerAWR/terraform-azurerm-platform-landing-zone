module "security_resource_group" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.2.1"

  location = var.primary_region
  name     = var.security_settings.resource_group_name

  providers = {
    azurerm = azurerm.security
  }
}

module "security_log_analytics_workspace" {
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "0.4.2"

  enable_telemetry                          = var.enable_telemetry
  location                                  = var.primary_region
  resource_group_name                       = module.security_resource_group.name
  name                                      = var.security_settings.log_analytics_workspace_name
  log_analytics_workspace_retention_in_days = 365
  log_analytics_workspace_sku               = "PerGB2018"

  providers = {
    azurerm = azurerm.security
    azapi   = azapi.security
  }
}

resource "azurerm_log_analytics_solution" "sentinel" {
  solution_name         = "SecurityInsights"
  location              = var.primary_region
  resource_group_name   = module.security_resource_group.name
  workspace_resource_id = module.security_log_analytics_workspace.resource_id
  workspace_name        = module.security_log_analytics_workspace.resource.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }

  provider = azurerm.security
}