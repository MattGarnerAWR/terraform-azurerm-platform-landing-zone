module "amba_alz" {
  source  = "Azure/avm-ptn-monitoring-amba-alz/azurerm"
  version = "0.3.0"

  count = var.amba_settings.bring_your_own_user_assigned_managed_identity ? 0 : 1

  location                            = var.amba_settings.location
  root_management_group_name          = local.root_management_group_name
  resource_group_name                 = var.amba_settings.resource_group_name
  user_assigned_managed_identity_name = var.amba_settings.user_assigned_managed_identity_name
}