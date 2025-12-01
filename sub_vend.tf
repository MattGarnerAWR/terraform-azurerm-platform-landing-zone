resource "azurerm_role_assignment" "sub_vend_spn_not_in_use" {
  scope                = module.alz.management_group_resource_ids["${local.root_management_group_name}-not-in-use"]
  role_definition_id = module.alz.role_definition_resource_ids["${local.root_management_group_name}/Subscription-Mover"]
  principal_id         = "cfaf1e73-c544-44f9-83b5-a7d22c8434e0"
}

resource "azurerm_role_assignment" "sub_vend_spn_landing_zones" {
  scope                = module.alz.management_group_resource_ids["${local.root_management_group_name}-landingzones"]
  role_definition_id = module.alz.role_definition_resource_ids["${local.root_management_group_name}/Subscription-Mover"]
  principal_id         = "cfaf1e73-c544-44f9-83b5-a7d22c8434e0"
}