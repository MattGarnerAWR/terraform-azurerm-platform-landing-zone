locals {
  subscription_mover_role_definition_id = replace(module.alz.role_definition_resource_ids["${local.root_management_group_name}/Subscription-Mover"], "/providers/Microsoft.Management/managementGroups/${local.root_management_group_name}", "")
}

resource "azurerm_role_assignment" "sub_vend_spn_not_in_use" {
  scope              = module.alz.management_group_resource_ids["${local.root_management_group_name}-not-in-use"]
  role_definition_id = local.subscription_mover_role_definition_id
  principal_id       = "cfaf1e73-c544-44f9-83b5-a7d22c8434e0"
}

resource "azurerm_role_assignment" "sub_vend_spn_landing_zones" {
  scope              = module.alz.management_group_resource_ids["${local.root_management_group_name}-landingzones"]
  role_definition_id = local.subscription_mover_role_definition_id
  principal_id       = "cfaf1e73-c544-44f9-83b5-a7d22c8434e0"
}

resource "azurerm_role_assignment" "sub_vend_spn_sandbox" {
  scope              = module.alz.management_group_resource_ids["${local.root_management_group_name}-sandbox"]
  role_definition_id = local.subscription_mover_role_definition_id
  principal_id       = "cfaf1e73-c544-44f9-83b5-a7d22c8434e0"
}