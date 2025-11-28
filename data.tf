data "azurerm_client_config" "current" {}

data "azurerm_role_definition" "owner" {
  name = "Owner"
}

data "azurerm_role_definition" "pim_roles" {
  for_each = var.management_group_pim_roles

  name = each.value.role_definition_name
}