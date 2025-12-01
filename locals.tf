locals {
  policy_default_values = {
    ama_change_tracking_data_collection_rule_id = jsonencode({
      value = "/subscriptions/${var.mgmt_sub_id}/resourceGroups/${var.management_resource_settings.resource_group_name}/providers/Microsoft.Insights/dataCollectionRules/${var.management_resource_settings.data_collection_rules.change_tracking.name}"
    })
    ama_mdfc_sql_data_collection_rule_id = jsonencode({
      value = "/subscriptions/${var.mgmt_sub_id}/resourceGroups/${var.management_resource_settings.resource_group_name}/providers/Microsoft.Insights/dataCollectionRules/${var.management_resource_settings.data_collection_rules.defender_sql.name}"
    })
    ama_vm_insights_data_collection_rule_id = jsonencode({
      value = "/subscriptions/${var.mgmt_sub_id}/resourceGroups/${var.management_resource_settings.resource_group_name}/providers/Microsoft.Insights/dataCollectionRules/${var.management_resource_settings.data_collection_rules.vm_insights.name}"
    })
    ama_user_assigned_managed_identity_id = jsonencode({
      value = "/subscriptions/${var.mgmt_sub_id}/resourceGroups/${var.management_resource_settings.resource_group_name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${var.management_resource_settings.user_assigned_managed_identities.ama.name}"
    })
    ama_user_assigned_managed_identity_name = jsonencode({
      value = var.management_resource_settings.user_assigned_managed_identities["ama"].name
    })
    log_analytics_workspace_id = jsonencode({
      value = "/subscriptions/${var.mgmt_sub_id}/resourceGroups/${var.management_resource_settings.resource_group_name}/providers/Microsoft.OperationalInsights/workspaces/${var.management_resource_settings.log_analytics_workspace_name}"
    })
    private_dns_zone_subscription_id = jsonencode({
      value = var.connectivity_sub_id
    })
    private_dns_zone_region = jsonencode({
      value = var.primary_region
    })
    private_dns_zone_resource_group_name = jsonencode({
      value = module.connectivity_resource_groups["dns"].name
    })

    # AMBA policy defaults
    amba_alz_management_subscription_id = jsonencode({
      value = var.mgmt_sub_id
    })
    amba_alz_resource_group_location = jsonencode({
      value = var.amba_settings.location
    })
    amba_alz_resource_group_name = jsonencode({
      value = var.amba_settings.resource_group_name
    })
    amba_alz_resource_group_tags = jsonencode({
      value = var.tags
    })
    amba_alz_user_assigned_managed_identity_name = jsonencode({
      value = var.amba_settings.user_assigned_managed_identity_name
    })
    amba_alz_byo_user_assigned_managed_identity_id = jsonencode({
      value = var.amba_settings.bring_your_own_user_assigned_managed_identity_resource_id
    })
    amba_alz_disable_tag_name = jsonencode({
      value = var.amba_settings.amba_disable_tag_name
    })
    amba_alz_disable_tag_values = jsonencode({
      value = var.amba_settings.amba_disable_tag_values
    })
    amba_alz_action_group_email = jsonencode({
      value = var.amba_settings.amba_action_group_email
    })
  }
  policy_assignments_to_modify = { for management_group_key, management_group_value in try(var.management_group_settings.policy_assignments_to_modify, {}) : management_group_key => {
    policy_assignments = { for policy_assignment_key, policy_assignment_value in management_group_value.policy_assignments : policy_assignment_key => {
      enforcement_mode        = try(policy_assignment_value.enforcement_mode, null)
      identity                = try(policy_assignment_value.identity, null)
      identity_ids            = try(policy_assignment_value.identity_ids, null)
      parameters              = merge(try({ for parameter_key, parameter_value in policy_assignment_value.parameters : parameter_key => jsonencode({ value = parameter_value }) }, {}), try(local.policy_assignment_parameters[policy_assignment_key], {}))
      non_compliance_messages = try(policy_assignment_value.non_compliance_messages, null)
      resource_selectors      = try(policy_assignment_value.resource_selectors, null)
      overrides               = try(policy_assignment_value.overrides, null)
    } }
  } }
  default_retries = {
    management_groups = {
      error_message_regex = ["AuthorizationFailed", "Permission to Microsoft.Management/managementGroups on resources of type 'Write' is required on the management group or its ancestors."]
    }
    role_definitions = {
      error_message_regex = ["AuthorizationFailed"]
    }
    policy_definitions = {
      error_message_regex = ["AuthorizationFailed"]
    }
    policy_set_definitions = {
      error_message_regex = ["AuthorizationFailed"]
    }
    policy_assignments = {
      error_message_regex = ["AuthorizationFailed", "The policy definition specified in policy assignment '.+' is out of scope"]
    }
    policy_role_assignments = {
      error_message_regex = ["AuthorizationFailed", "ResourceNotFound", "RoleAssignmentNotFound"]
    }
    hierarchy_settings = {
      error_message_regex = ["AuthorizationFailed"]
    }
    subscription_placement = {
      error_message_regex = ["AuthorizationFailed"]
    }
  }
  default_timeouts = {
    management_group = {
      create = "60m"
      read   = "60m"
    }
    role_definition = {
      create = "60m"
      read   = "60m"
    }
    policy_assignment = {
      create = "60m"
      read   = "60m"
    }
    policy_definition = {
      create = "60m"
      read   = "60m"
    }
    policy_set_definition = {
      create = "60m"
      read   = "60m"
    }
    policy_role_assignment = {
      create = "60m"
      read   = "60m"
    }
  }
  #-------DNS zones-------
  resource_group = "rg-private-dns-prd-001"

  dns_zone_ids = {
    azureMachineLearningWorkspacePrivateDnsZoneId       = "privatelink.api.azureml.ms"
    azureServiceBusNamespacePrivateDnsZoneId            = "privatelink.servicebus.windows.net"
    azureMediaServicesStreamPrivateDnsZoneId            = "privatelink.media.azure.net"
    azureEventHubNamespacePrivateDnsZoneId              = "privatelink.eventgrid.azure.net"
    azureEventGridDomainsPrivateDnsZoneId               = "privatelink.eventgrid.azure.net"
    azureDataFactoryPortalPrivateDnsZoneId              = "privatelink.adf.azure.com"
    azureAutomationWebhookPrivateDnsZoneId              = "privatelink.azure-automation.net"
    azureMediaServicesLivePrivateDnsZoneId              = "privatelink.media.azure.net"
    azureCognitiveSearchPrivateDnsZoneId                = "privatelink.search.windows.net"
    azureEventGridTopicsPrivateDnsZoneId                = "privatelink.eventgrid.azure.net"
    azureMediaServicesKeyPrivateDnsZoneId               = "privatelink.media.azure.net"
    azureStorageStaticWebSecPrivateDnsZoneId            = "privatelink.web.core.windows.net"
    azureCosmosCassandraPrivateDnsZoneId                = "privatelink.cassandra.cosmos.azure.com"
    azureAutomationDSCHybridPrivateDnsZoneId            = "privatelink.azure-automation.net"
    azureCognitiveServicesPrivateDnsZoneId              = "privatelink.cognitiveservices.azure.com"
    azureCosmosGremlinPrivateDnsZoneId                  = "privatelink.gremlin.cosmos.azure.com"
    azureStorageStaticWebPrivateDnsZoneId               = "privatelink.web.core.windows.net"
    azureStorageQueuePrivateDnsZoneId                   = "privatelink.queue.core.windows.net"
    azureSynapseSQLODPrivateDnsZoneId                   = "privatelink.sql.azuresynapse.net"
    azureStorageQueueSecPrivateDnsZoneId                = "privatelink.queue.core.windows.net"
    azureAppServicesPrivateDnsZoneId                    = "privatelink.azurewebsites.net"
    azureStorageFilePrivateDnsZoneId                    = "privatelink.file.core.windows.net"
    azureStorageBlobPrivateDnsZoneId                    = "privatelink.blob.core.windows.net"
    azureDataFactoryPrivateDnsZoneId                    = "privatelink.datafactory.azure.net"
    azureCosmosMongoPrivateDnsZoneId                    = "privatelink.mongo.cosmos.azure.com"
    azureCosmosTablePrivateDnsZoneId                    = "privatelink.table.cosmos.azure.com"
    azureRedisCachePrivateDnsZoneId                     = "privatelink.redis.cache.windows.net"
    azureDiskAccessPrivateDnsZoneId                     = "privatelink.dev.azuresynapse.net"
    azureStorageBlobSecPrivateDnsZoneId                 = "privatelink.blob.core.windows.net"
    azureSynapseSQLPrivateDnsZoneId                     = "privatelink.sql.azuresynapse.net"
    azureStorageDFSPrivateDnsZoneId                     = "privatelink.dfs.core.windows.net"
    azureSynapseDevPrivateDnsZoneId                     = "privatelink.dev.azuresynapse.net"
    azureStorageDFSSecPrivateDnsZoneId                  = "privatelink.dfs.core.windows.net"
    azureHDInsightPrivateDnsZoneId                      = "privatelink.azurehdinsight.net"
    azureCosmosSQLPrivateDnsZoneId                      = "privatelink.documents.azure.com"
    azureKeyVaultPrivateDnsZoneId                       = "privatelink.vaultcore.azure.net"
    azureMonitorPrivateDnsZoneId1                       = "privatelink.monitor.azure.com"
    azureMonitorPrivateDnsZoneId2                       = "privatelink.oms.opinsights.azure.com"
    azureMonitorPrivateDnsZoneId3                       = "privatelink.ods.opinsights.azure.com"
    azureMonitorPrivateDnsZoneId4                       = "privatelink.agentsvc.azure-automation.net"
    azureMonitorPrivateDnsZoneId5                       = "privatelink.monitor.azure.com"
    azureIotHubsPrivateDnsZoneId                        = "privatelink.azure-devices.net"
    azureSignalRPrivateDnsZoneId                        = "privatelink.service.signalr.net"
    azureBatchPrivateDnsZoneId                          = "privatelink.batch.azure.com"
    azureFilePrivateDnsZoneId                           = "privatelink.afs.azure.net"
    azureMigratePrivateDnsZoneId                        = "privatelink.prod.migration.windowsazure.com"
    azureAcrPrivateDnsZoneId                            = "privatelink.azurecr.io"
    azureWebPrivateDnsZoneId                            = "privatelink.azurewebsites.net"
    azureDatabricksPrivateDnsZoneId                     = "privatelink.azuredatabricks.net"
    azureMachineLearningWorkspaceSecondPrivateDnsZoneId = "privatelink.notebooks.azure.net"
    azureIotPrivateDnsZoneId                            = "privatelink.azure-devices-provisioning.net"
    azureAppPrivateDnsZoneId                            = "privatelink.azconfig.io"
    azureAsrPrivateDnsZoneId                            = "privatelink.siterecovery.windowsazure.com"
    azureArcKubernetesConfigurationPrivateDnsZoneId     = "privatelink.dp.kubernetesconfiguration.azure.com"
    azureArcHybridResourceProviderPrivateDnsZoneId      = "privatelink.his.arc.azure.com"
    azureManagedGrafanaWorkspacePrivateDnsZoneId        = "privatelink.grafana.azure.com"
    azureVirtualDesktopWorkspacePrivateDnsZoneId        = "privatelink.wvd.microsoft.com"
    azureVirtualDesktopHostpoolPrivateDnsZoneId         = "privatelink.wvd.microsoft.com"
    azureArcGuestconfigurationPrivateDnsZoneId          = "privatelink.guestconfiguration.azure.com"
    azureStorageTableSecondaryPrivateDnsZoneId          = "privatelink.table.cosmos.azure.com"
    azureIotDeviceupdatePrivateDnsZoneId                = "privatelink.azureiotcentral.com"
    azureStorageTablePrivateDnsZoneId                   = "privatelink.table.cosmos.azure.com"
    azureSiteRecoveryBackupPrivateDnsZoneId             = "privatelink.ne.backup.windowsazure.com"
    azureSiteRecoveryQueuePrivateDnsZoneId              = "privatelink.queue.core.windows.net"
    azureSiteRecoveryBlobPrivateDnsZoneId               = "privatelink.blob.core.windows.net"
    azureBotServicePrivateDnsZoneId                     = "privatelink.directline.botframework.com"
    azureIotCentralPrivateDnsZoneId                     = "privatelink.azureiotcentral.com"
  }

  dns_zone_parameters = {
    for key, zone in local.dns_zone_ids :
    key => jsonencode({
      value = "/subscriptions/${var.connectivity_sub_id}/resourceGroups/${var.connectivity_resource_groups.dns.name}/providers/Microsoft.Network/privateDnsZones/${zone}"
    })
  }

  policy_assignment_parameters = {
    "Deploy-AzActivity-Log" = {
      logAnalytics = jsonencode({
        value = "/subscriptions/${var.security_sub_id}/resourceGroups/rg-security-prd-001/providers/Microsoft.OperationalInsights/workspaces/log-security-prd-uks-001"
      })
    }
    "Deploy-Private-DNS-Zones" = local.dns_zone_parameters
  }

  hub_virtual_networks = {
    primary = merge(
      var.hub_virtual_networks.primary,
      {
        default_parent_id = module.connectivity_resource_groups["vnet_primary"].resource_id
      },
      {
        private_dns_zones = merge(
          try(var.hub_virtual_networks.primary.private_dns_zones, {}),
          {
            parent_id = module.connectivity_resource_groups["dns"].resource_id
          }
        )
      }
    )
  }

  lz_custom_sub_owner = trimprefix(module.alz.role_definition_resource_ids["mattg-root/Subscription-Owner"], "/providers/Microsoft.Management/managementGroups/mattg-root/providers/Microsoft.Authorization/roleDefinitions/")

  excluded_privileged_roles = [
    "8e3af657-a8ff-443c-a75c-2fe8c4bcb635", # Owner
    "b24988ac-6180-42a0-ab88-20f7382dd24c", # Contributor
    "92b92042-07d9-4307-87f7-36a593fc5850", # Azure File Sync Administrator  
    "a8889054-8d42-49c9-bc1c-52486c10e7cd", # Reservations Administrator
    "f58310d9-a9f6-439a-9e8d-f62e7b41a168", # Role Based Access Control Administrator
    "18d7d88d-d35e-4fb5-a5c3-7773c20a72d9", # User Access Administrator
    "a2b7cc47-30ec-462f-a2f4-9ac6e1c266af", # Azure Resilience Management Goals Administrator	
    local.lz_custom_sub_owner               # LZ Custom Owner
  ]

  # Reusable condition builder
  condition_builder = {
    "exclude_privileged_roles" = "((!(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})) OR (@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAllValues:GuidNotEquals {${join(", ", local.excluded_privileged_roles)}})) AND ((!(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})) OR (@Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAllValues:GuidNotEquals {${join(", ", local.excluded_privileged_roles)}}))"
  }

  # Build conditions for PIM roles
  pim_built_conditions = {
    for k, v in var.management_group_pim_roles : k => v.condition_template != null ? local.condition_builder[v.condition_template] : null
  }

  root_management_group_name = keys(module.alz.management_group_resource_ids)[0]
}