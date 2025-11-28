module "connectivity_resource_groups" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.2.1"

  for_each = var.connectivity_resource_groups

  name             = each.value.name
  location         = each.value.location
  enable_telemetry = var.enable_telemetry
  tags             = var.tags

  providers = {
    azurerm = azurerm.connectivity
  }
}

module "hub_and_spoke_vnet" {
  source  = "Azure/avm-ptn-alz-connectivity-hub-and-spoke-vnet/azurerm"
  version = "0.16.2"

  hub_and_spoke_networks_settings = var.hub_and_spoke_networks_settings
  hub_virtual_networks            = local.hub_virtual_networks
  enable_telemetry                = var.enable_telemetry
  tags                            = var.tags

  providers = {
    azurerm = azurerm.connectivity
    azapi   = azapi.connectivity
  }
}

# locals {
#   connectivity_resources_for_locking = merge(
#     { for key, value in module.hub_and_spoke_vnet.virtual_network_resource_ids : "vnet_${key}" => value },
#     { for key, value in module.hub_and_spoke_vnet.firewall_resource_ids : "firewall_${key}" => value },
#     { for key, value in module.hub_and_spoke_vnet.route_tables_firewall : "rt_firewall_${key}" => value.id },
#     { for key, value in module.hub_and_spoke_vnet.route_tables_user_subnets : "rt_user_subnets_${key}" => value.id },
#     merge(values({ for key, value in module.hub_and_spoke_vnet.private_dns_zone_resource_ids : key => {
#       for dns_zone in value : "private_dns_${key}_${dns_zone}" => dns_zone }
#     })...)
#   )
# }

# resource "azurerm_management_lock" "connectivity" {
#   for_each = local.connectivity_resources_for_locking

#   name       = "CanNotDelete"
#   scope      = each.value
#   lock_level = "CanNotDelete"
#   notes      = "Managed by Terraform"

#   provider = azurerm.connectivity
# }
