resource "azurerm_role_assignment" "sub_vend_spn_not_in_use" {
  scope                = module.alz.management_group_resource_ids["${local.root_management_group_name}-not-in-use"]
  role_definition_id = module.alz.role_definition_resource_ids["${local.root_management_group_name}/Subscription-Mover"]
  principal_id         = "7a4b6093-283d-4e85-a8d4-6a2573c923c7"
}

resource "azurerm_role_assignment" "sub_vend_spn_landing_zones" {
  scope                = module.alz.management_group_resource_ids["${local.root_management_group_name}-landingzones"]
  role_definition_id = module.alz.role_definition_resource_ids["${local.root_management_group_name}/Subscription-Mover"]
  principal_id         = "7a4b6093-283d-4e85-a8d4-6a2573c923c7"
}