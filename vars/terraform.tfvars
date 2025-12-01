mgmt_sub_id         = "8be4ef68-af99-4631-8f50-d8bdb4d822d8"
connectivity_sub_id = "8be4ef68-af99-4631-8f50-d8bdb4d822d8"
security_sub_id     = "8be4ef68-af99-4631-8f50-d8bdb4d822d8"

primary_region = "uksouth"

management_resource_settings = {
  enabled                      = true
  location                     = "uksouth"
  log_analytics_workspace_name = "log-mgmt-prd-uks-001"
  resource_group_name          = "rg-mgmt-prd-001"
  user_assigned_managed_identities = {
    ama = {
      name = "id-ama-prd-uks-001"
    }
  }
  data_collection_rules = {
    change_tracking = {
      name = "dcr-change-tracking-prd-uks-001"
    }
    defender_sql = {
      name = "dcr-defender-sql-prd-uks-001"
    }
    vm_insights = {
      name = "dcr-vm-insights-prd-uks-001"
    }
  }
}

enable_telemetry = false

management_group_settings = {
  enable_telemetry = true
  location         = "uksouth"
  subscription_placement = {
    connectivity = {
      subscription_id       = "8be4ef68-af99-4631-8f50-d8bdb4d822d8"
      management_group_name = "mattg-connectivity"
    }
    # management = {
    #   subscription_id       = "eeabfded-606c-4c07-bd4b-f84be0a8573b"
    #   management_group_name = "rw-management"
    # }
    # bootstrap = {
    #   subscription_id       = "7f38509d-63c4-4837-a2f6-35247d707f06"
    #   management_group_name = "rw-cloudoperations"
    # }
    # security = {
    #   subscription_id       = "7f38509d-63c4-4837-a2f6-35247d707f06"
    #   management_group_name = "security"
    # }
  }
  policy_assignments_to_modify = {
    mattg-root = {
      policy_assignments = {
        Deploy-MDFC-Config-H224 = {
          parameters = {
            ascExportResourceGroupName                  = "rg-asc-export-prd-001"
            ascExportResourceGroupLocation              = "UKSouth"
            emailSecurityContact                        = "m.garner@reply.com"
            enableAscForServers                         = "DeployIfNotExists"
            enableAscForServersVulnerabilityAssessments = "DeployIfNotExists"
            enableAscForSql                             = "DeployIfNotExists"
            enableAscForAppServices                     = "DeployIfNotExists"
            enableAscForStorage                         = "DeployIfNotExists"
            enableAscForContainers                      = "DeployIfNotExists"
            enableAscForKeyVault                        = "DeployIfNotExists"
            enableAscForSqlOnVm                         = "DeployIfNotExists"
            enableAscForArm                             = "DeployIfNotExists"
            enableAscForOssDb                           = "DeployIfNotExists"
            enableAscForCosmosDbs                       = "DeployIfNotExists"
            enableAscForCspm                            = "DeployIfNotExists"
          }
        }
        Deploy-AzActivity-Log = {}
      }
    }
    mattg-connectivity = {
      policy_assignments = {
        Enable-DDoS-VNET = {
          parameters = {
            effect = "Disabled"
          }
        }
      }
    }
    mattg-landingzones = {
      policy_assignments = {
        Enable-DDoS-VNET = {
          parameters = {
            effect = "Disabled"
          }
        }
      }
    }
    mattg-private = {
      policy_assignments = {
        Deploy-Private-DNS-Zones = {}
      }
    }
  }
  /*
  # Example of how to add management group role assignments
  management_group_role_assignments = {
    root_owner_role_assignment = {
      management_group_name      = "root"
      role_definition_id_or_name = "Owner"
      principal_id               = "00000000-0000-0000-0000-000000000000"
    }
  }
  */
}

management_group_pim_roles = {
  root_uaa = {
    management_group_name = "mattg-root"
    role_definition_name  = "User Access Administrator"
    approver_group_key    = "platform"
  }
  root_contributor = {
    management_group_name = "mattg-root"
    role_definition_name  = "Contributor"
    approver_group_key    = "platform"
  }
  root_reader = {
    management_group_name = "mattg-root"
    role_definition_name  = "Reader"
  }
  security_contributor = {
    management_group_name = "mattg-security"
    role_definition_name  = "Contributor"
    approver_group_key    = "security"
  }
  security_reader = {
    management_group_name = "mattg-security"
    role_definition_name  = "Reader"
  }
  security_rbac_admin = {
    management_group_name = "mattg-security"
    role_definition_name  = "Role Based Access Control Administrator"
    condition_template    = "exclude_privileged_roles"
    approver_group_key    = "security"
  }
}

management_group_pim_approver_groups = [
  "platform",
  "security"
]


#---------------connectivity------------
/*
--- Connectivity - Hub and Spoke Virtual Network ---
You can use this section to customize the hub virtual networking that will be deployed.
*/
connectivity_type = "hub_and_spoke_vnet"

connectivity_resource_groups = {
  # ddos = {
  #   name     = "rg-ddos-prd-001"
  #   location = "uksouth"
  #   settings = {
  #     enabled = false
  #   }
  # }

  vnet_primary = {
    name     = "rg-hub-prd-001"
    location = "uksouth"
    settings = {
      enabled = true
    }
  }
  dns = {
    name     = "rg-privatelink-dns-prd-001"
    location = "uksouth"
    settings = {
      enabled = true
    }
  }
}


hub_and_spoke_networks_settings = {
  enabled_resources = {
    ddos_protection_plan = "false"
  }
  # ddos_protection_plan = {
  #   enabled             = false
  #   name                = "ddos"
  #   resource_group_name = "rg-connectivity-ddos-prd-001"
  #   location            = "uksouth"
  # }
}


hub_virtual_networks = {
  primary = {
    location = "uksouth"
    enabled_resources = {
      firewall                              = "false"
      bastion                               = "false"
      virtual_network_gateway_express_route = "false"
      virtual_network_gateway_vpn           = "false"
      private_dns_zones                     = "true"
      private_dns_resolver                  = "false"
    }
    hub_virtual_network = {
      name                          = "vnet-hub-prd-uks-001"
      address_space                 = ["10.180.0.0/24"]
      routing_address_space         = []
      route_table_name_firewall     = "rt-azfw-prd-uks-001"
      route_table_name_user_subnets = "rt-user-prd-uks-001"
      subnets                       = {}
    }
    firewall = {
      subnet_address_prefix            = "10.180.0.0/26"
      management_subnet_address_prefix = "10.180.0.192/26"
      name                             = "fw-hub-prd-uks-001"
      sku_tier                         = "Basic"
      default_ip_configuration = {
        public_ip_config = {
          name = "pip-fw-hub-prd-uks-001"
        }
      }
      management_ip_configuration = {
        public_ip_config = {
          name = "pip-fw-hub-mgmt-prd-uks-001"
        }
      }
    }
    firewall_policy = {
      name = "afwp-hub-prd-uks-001"
      sku  = "Basic"
    }

    private_dns_zones = {
      private_link_private_dns_zones_regex_filter = {
        enabled = false
      }
      auto_registration_zone_enabled = false
      # auto_registration_zone_name = null
    }
    private_dns_resolver = {
      subnet_address_prefix = "10.180.0.64/28"
      # subnet_name           = "snet-dns-resolver"
      name = "dnspr-hub-uks-001"
    }
    bastion = {
      subnet_address_prefix = "10.180.0.128/26"
      name                  = "bas-hub-prd-uks-001"
      # bastion_host = {
      #   name  = "bas-hub-prd-uks-001"
      #   zones = [1, 2, 3]
      # }
      bastion_public_ip = {
        name = "pip-bas-hub-prd-uks-001"
        # zones = [1, 2, 3]
      }
    }
  }
}

#---------Security-------------------------

security_settings = {
  resource_group_name          = "rg-security-prd-001"
  log_analytics_workspace_name = "log-security-prd-uks-001"
}

#---------AMBA-----------------------------
amba_settings = {
  location                                                  = "uksouth"
  resource_group_name                                       = "rg-amba-monitoring-prd-001"
  user_assigned_managed_identity_name                       = "id-amba-prd-uks-001"
  bring_your_own_user_assigned_managed_identity             = false
  bring_your_own_user_assigned_managed_identity_resource_id = ""
  amba_disable_tag_name                                     = "MonitorDisable"
  amba_disable_tag_values                                   = ["true", "Test", "Dev", "Sandbox"]
  amba_action_group_email                                   = ["m.garner@reply.com"]

}

tags = {}