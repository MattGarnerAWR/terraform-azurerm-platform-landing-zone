module "alz" {
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "v0.14.1"

  architecture_name                                             = "MattG"
  parent_resource_id                                            = data.azurerm_client_config.current.tenant_id
  location                                                      = var.management_group_settings.location
  policy_default_values                                         = local.policy_default_values
  policy_assignments_to_modify                                  = local.policy_assignments_to_modify
  delays                                                        = try(var.management_group_settings.delays, {})
  enable_telemetry                                              = var.enable_telemetry
  management_group_hierarchy_settings                           = try(var.management_group_settings.management_group_hierarchy_settings, null)
  partner_id                                                    = try(var.management_group_settings.partner_id, null)
  retries                                                       = try(var.management_group_settings.retries, local.default_retries)
  subscription_placement                                        = try(var.management_group_settings.subscription_placement, {})
  timeouts                                                      = try(var.management_group_settings.timeouts, local.default_timeouts)
  override_policy_definition_parameter_assign_permissions_set   = try(var.management_group_settings.override_policy_definition_parameter_assign_permissions_set, null)
  override_policy_definition_parameter_assign_permissions_unset = try(var.management_group_settings.override_policy_definition_parameter_assign_permissions_unset, null)
  management_group_role_assignments                             = try(var.management_group_settings.management_group_role_assignments, null)
  role_assignment_definition_lookup_enabled                     = try(var.management_group_settings.role_assignment_definition_lookup_enabled, true)
  dependencies = {
    policy_role_assignments = [
      module.management_resources,
      module.connectivity_resource_groups,
      module.hub_and_spoke_vnet
    ]
  }
}
