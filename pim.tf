resource "azuread_group_without_members" "pim_roles" {
  for_each = var.management_group_pim_roles

  display_name     = "pim-sg-az-${each.value.management_group_name}-${lower(replace(each.value.role_definition_name, " ", "-"))}"
  security_enabled = true
}

resource "azuread_group_without_members" "pim_approvers" {
  for_each = toset(var.management_group_pim_approver_groups)

  display_name     = "pim-sg-az-${lower(each.value)}-approvers"
  security_enabled = true
}

resource "azurerm_role_management_policy" "pim_roles" {
  for_each = var.management_group_pim_roles

  scope              = module.alz.management_group_resource_ids[each.value.management_group_name]
  role_definition_id = data.azurerm_role_definition.pim_roles[each.key].role_definition_id

  activation_rules {
    maximum_duration                   = "PT8H"
    require_approval                   = each.value.approver_group_key != null ? true : false
    require_justification              = true
    require_multifactor_authentication = true
    require_ticket_info                = true

    dynamic "approval_stage" {
      for_each = each.value.approver_group_key != null ? [each.value.approver_group_key] : []
      content {
        primary_approver {
          object_id = azuread_group_without_members.pim_approvers[approval_stage.value].object_id
          type      = "Group"
        }
      }
    }
  }

  active_assignment_rules {
    expire_after          = "P15D"
    require_justification = true
  }

  eligible_assignment_rules {
    expiration_required = false
  }


  notification_rules {
    eligible_activations {
      admin_notifications {
        default_recipients = true
        notification_level = "Critical"
      }
      approver_notifications {
        default_recipients = true
        notification_level = "Critical"
      }
      assignee_notifications {
        default_recipients = true
        notification_level = "Critical"
      }
    }
  }

  #   lifecycle {
  #     ignore_changes = [activation_rules]
  #   }
}

resource "azurerm_pim_eligible_role_assignment" "pim_roles" {
  for_each = var.management_group_pim_roles

  scope              = azurerm_role_management_policy.pim_roles[each.key].scope
  role_definition_id = azurerm_role_management_policy.pim_roles[each.key].role_definition_id
  principal_id       = azuread_group_without_members.pim_roles[each.key].object_id

  condition         = each.value.condition_template != null ? local.pim_built_conditions[each.key] : null
  condition_version = each.value.condition_template != null ? "2.0" : null
}
