resource "azurerm_app_service_plan" "app_service_plan" {
  count                        = var.plan_name != null ? 1 : 0
  name                         = var.plan_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  kind                         = var.kind
  maximum_elastic_worker_count = var.maximum_elastic_worker_count
  sku {
    tier     = var.sku["tier"]
    size     = var.sku["size"]
    capacity = try(var.sku["capacity"], null)
  }
  app_service_environment_id = var.app_service_environment_id
  reserved                   = var.reserved
  per_site_scaling           = var.per_site_scaling
  is_xenon                   = var.is_xenon
  zone_redundant             = var.zone_redundant
  tags                       = local.tags
  lifecycle {
    ignore_changes = [
      tags["create_date"]
    ]
  }
}

resource "azurerm_app_service" "app_service" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  app_service_plan_id = var.app_service_plan_id == null ? azurerm_app_service_plan.app_service_plan.id : var.app_service_plan_id
  app_settings        = var.app_settings
  dynamic "auth_settings" {
    for_each = var.auth_settings != null ? [var.auth_settings] : []
    content {
      enabled = auth_settings.value.enabled
      dynamic "active_directory" {
        for_each = auth_settings.value.active_directory
        content {
          client_id         = active_directory.value.client_id
          client_secret     = lookup(active_directory.value, "client_secret", null)
          allowed_audiences = lookup(active_directory.value, "allowed_audiences", null)
        }
      }
      additional_login_params        = lookup(auth_settings.value, "additional_login_params", null)
      allowed_external_redirect_urls = lookup(auth_settings.value, "allowed_external_redirect_urls", null)
      default_provider               = lookup(auth_settings.value, "default_provider", null)
      dynamic "facebook" {
        for_each = auth_settings.value.facebook
        content {
          app_id       = facebook.value.app_id
          app_secret   = facebook.value.app_secret
          oauth_scopes = lookup(facebook.value, "oauth_scopes", null)
        }
      }
      dynamic "google" {
        for_each = auth_settings.value.google
        content {
          client_id     = google.value.client_id
          client_secret = google.value.client_secret
          oauth_scopes  = lookup(google.value, "oauth_scopes", null)
        }
      }
      issuer = lookup(auth_settings.value, "issuer", null)
      dynamic "microsoft" {
        for_each = auth_settings.value.microsoft
        content {
          client_id     = microsoft.value.client_id
          client_secret = microsoft.value.client_secret
          oauth_scopes  = lookup(microsoft.value, "oauth_scopes", null)
        }
      }
      runtime_version               = lookup(auth_settings.value, "runtime_version", null)
      token_refresh_extension_hours = lookup(auth_settings.value, "token_refresh_extension_hours", 72)
      token_store_enabled           = lookup(auth_settings.value, "token_store_enabled", false)
      dynamic "twitter" {
        for_each = auth_settings.value.twitter
        content {
          consumer_key    = twitter.value.consumer_key
          consumer_secret = twitter.value.consumer_secret
        }
      }
      unauthenticated_client_action = lookup(auth_settings.value, "unauthenticated_client_action", null)
    }
  }
  dynamic "backup" {
    for_each = var.backup != null ? [var.backup] : []
    content {
      name                = backup.value.name
      enabled             = lookup(backup.value, "enabled", true)
      storage_account_url = backup.value.storage_account_url
      dynamic "schedule" {
        for_each = backup.value.schedule
        content {
          frequency_interval       = schedule.value.frequency_interval
          frequency_unit           = schedule.value.frequency_unit
          keep_at_least_one_backup = lookup(schedule.value, "keep_at_least_one_backup", null)
          retention_period_in_days = lookup(schedule.value, "retention_period_in_days", 30)
          start_time               = lookup(schedule.value, "start_time", null)
        }
      }
    }
  }
  dynamic "connection_string" {
    for_each = var.connection_string
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }
  client_affinity_enabled = var.client_affinity_enabled
  client_cert_enabled     = var.client_cert_enabled
  client_cert_mode        = var.client_cert_mode
  enabled                 = var.enabled
  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
  https_only                      = var.https_only
  key_vault_reference_identity_id = var.key_vault_reference_identity_id
  dynamic "logs" {
    for_each = var.logs != null ? [var.logs] : []
    content {
      dynamic "application_logs" {
        for_each = logs.value.application_logs
        content {
          dynamic "azure_blob_storage " {
            for_each = application_logs.value
            content {
              level             = azure_blob_storage.value.level
              sas_url           = azure_blob_storage.value.sas_url
              retention_in_days = azure_blob_storage.value.retention_in_days
            }
            file_system_level = lookup(application_logs.value, "file_system_level", null)
          }
        }
      }
      dynamic "http_logs" {
        for_each = logs.value.http_logs
        content {
          dynamic "azure_blob_storage " {
            for_each = http_logs.value
            content {
              level             = azure_blob_storage.value.level
              sas_url           = azure_blob_storage.value.sas_url
              retention_in_days = azure_blob_storage.value.retention_in_days
            }
          }
          dynamic "file_system " {
            for_each = http_logs.value
            content {
              retention_in_days = file_system.value.retention_in_days
              retention_in_mb   = file_system.value.retention_in_mb
            }
          }
        }
      }
      detailed_error_messages_enabled = lookup(logs.value, "detailed_error_messages_enabled", false)
      failed_request_tracing_enabled  = lookup(logs.value, "failed_request_tracing_enabled", false)
    }
  }
  dynamic "storage_account" {
    for_each = var.storage_account
    content {
      name         = storage_account.value.name
      type         = storage_account.value.type
      account_name = storage_account.value.account_name
      share_name   = storage_account.value.share_name
      access_key   = storage_account.value.access_key
      mount_path   = lookup(storage_account.value, "mount_path", null)
    }
  }
  dynamic "site_config" {
    for_each = var.site_config
    content {
      acr_use_managed_identity_credentials = lookup(site_config.value, "acr_use_managed_identity_credentials", null)
      acr_user_managed_identity_client_id  = lookup(site_config.value, "acr_user_managed_identity_client_id", null)
      always_on                            = lookup(site_config.value, "always_on", false)
      app_command_line                     = lookup(site_config.value, "app_command_line", null)
      auto_swap_slot_name                  = lookup(site_config.value, "auto_swap_slot_name", null)
      dynamic "cors" {
        for_each = site_config.value.cors
        content {
          allowed_origins     = cors.value.allowed_origins
          support_credentials = lookup(cors.value, "support_credentials", null)
        }
      }
      default_documents           = lookup(site_config.value, "default_documents", null)
      dotnet_framework_version    = lookup(site_config.value, "dotnet_framework_version ", null)
      ftps_state                  = lookup(site_config.value, "ftps_state", null)
      health_check_path           = lookup(site_config.value, "health_check_path", null)
      number_of_workers           = lookup(site_config.value, "number_of_workers", null)
      http2_enabled               = lookup(site_config.value, "http2_enabled", false)
      ip_restriction              = lookup(site_config.value, "ip_restriction", null)
      scm_use_main_ip_restriction = lookup(site_config.value, "scm_use_main_ip_restriction", false)
      scm_ip_restriction          = lookup(site_config.value, "scm_ip_restriction", null)
      java_version                = lookup(site_config.value, "java_version", null)
      java_container              = lookup(site_config.value, "java_container", null)
      java_container_version      = lookup(site_config.value, "java_container_version", null)
      local_mysql_enabled         = lookup(site_config.value, "local_mysql_enabled", null)
      linux_fx_version            = lookup(site_config.value, "linux_fx_version", null)
      windows_fx_version          = lookup(site_config.value, "windows_fx_version", null)
      managed_pipeline_mode       = lookup(site_config.value, "managed_pipeline_mode ", "Integrated")
      min_tls_version             = lookup(site_config.value, "min_tls_version", "1.2")
      php_version                 = lookup(site_config.value, "php_version", null)
      python_version              = lookup(site_config.value, "python_version", null)
      remote_debugging_enabled    = lookup(site_config.value, "remote_debugging_enabled", false)
      remote_debugging_version    = lookup(site_config.value, "remote_debugging_version", null)
      scm_type                    = lookup(site_config.value, "scm_type", null)
      use_32_bit_worker_process   = lookup(site_config.value, "use_32_bit_worker_process", null)
      vnet_route_all_enabled      = lookup(site_config.value, "vnet_route_all_enabled", null)
      websockets_enabled          = lookup(site_config.value, "websockets_enabled", null)
    }
  }
  dynamic "source_control" {
    for_each = var.source_control
    content {
      repo_url           = lookup(source_control.value, "repo_url", null)
      branch             = lookup(source_control.value, "branch", "Master")
      manual_integration = lookup(source_control.value, "manual_integration", false)
      rollback_enabled   = lookup(source_control.value, "rollback_enabled", false)
      use_mercurial      = lookup(source_control.value, "use_mercurial", true)
    }
  }
  tags = var.tags
}