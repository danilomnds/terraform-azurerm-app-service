variable "plan_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "kind" {
  type    = string
  default = "Windows"
}

variable "maximum_elastic_worker_count" {
  type    = number
  default = null
}

variable "sku" {
  type = object({
    tier     = string
    size     = string
    capacity = optional(number)
  })
}

variable "app_service_environment_id" {
  type    = string
  default = null
}

/* needs to be confirmed
variable "reserved" {
  type = bool
  default = false
}


variable "per_site_scaling" {
  type = bool
  default = false
}

variable "is_xenon" {
  type    = bool
  default = false
}

variable "zone_redundant" {
  type    = bool
  default = false
}
*/

variable "tags" {
  type    = map(string)
  default = {}
}

variable "name" {
  type = string
}

variable "app_service_plan_id" {
  type    = string
  default = null
}

variable "app_settings" {
  type    = map(string)
  default = {}
}

variable "auth_settings" {
  type = object({
    enabled = bool
    active_directory = optional(object({
      client_id         = string
      client_secret     = optional(string)
      allowed_audiences = optional(string)
    }))
    additional_login_params        = map(string)
    allowed_external_redirect_urls = list(string)
    default_provider               = string
    facebook = object({
      app_id       = string
      app_secret   = string
      oauth_scopes = optional(string)
    })
    google = object({
      client_id     = string
      client_secret = string
      oauth_scopes  = optional(string)
    })
    issuer = string
    microsoft = object({
      client_id     = string
      client_secret = string
      oauth_scopes  = optional(string)
    })
    runtime_version               = string
    token_refresh_extension_hours = number
    token_store_enabled           = bool
    twitter = object({
      consumer_key    = string
      consumer_secret = string
    })
    unauthenticated_client_action = string
  })
  default = {}
}

variable "backup" {
  type = object({
    name                = string
    enabled             = optional(bool)
    storage_account_url = string
    schedule = object({
      frequency_interval       = number
      frequency_unit           = string
      keep_at_least_one_backup = optional(bool)
      retention_period_in_days = optional(number)
      start_time               = optional(string)
    })
  })
  default = {}
}

variable "connection_string" {
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  default = [{}]
}

/* check the default
variable "client_affinity_enabled" {
  type = bool
  default = false
  
}
*/

variable "client_cert_enabled" {
  type    = bool
  default = true
}

variable "client_cert_mode" {
  type    = string
  default = null
}

variable "enabled" {
  type    = bool
  default = true
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

variable "https_only" {
  type    = bool
  default = false
}

variable "key_vault_reference_identity_id" {
  type    = string
  default = null
}

variable "logs" {
  type = object({
    application_logs = optional(object({
      azure_blob_storage = optional(object({
        level             = string
        sas_url           = string
        retention_in_days = number
      }))
      file_system_level = optional(string)
    }))
    http_logs = optional(object({
      file_system = optional(object({
        retention_in_days = number
        retention_in_mb   = number
      }))
      azure_blob_storage = optional(object({
        level             = string
        sas_url           = string
        retention_in_days = number
      }))
    }))
  })
  default = null
}

variable "storage_account" {
  type = list(object({
    name         = string
    type         = string
    account_name = string
    share_name   = string
    acess_key    = string
    mount_path   = optional(string)
  }))
  default = [{}]
}

variable "site_config" {
  type = object({
    # variable type needs to be confirmed
    acr_use_managed_identity_credentials = optional(bool)
    acr_user_managed_identity_client_id  = optional(string)
    always_on                            = optional(bool)
    app_command_line                     = optional(string)
    auto_swap_slot_name                  = optional(string)
    cors = optional(object({
      allowed_origins     = list(string)
      support_credentials = optional(bool)
    }))
    # variable type needs to be confirmed
    default_documents           = optional(string)
    dotnet_framework_version    = optional(string)
    ftps_state                  = optional(string)
    health_check_path           = optional(string)
    number_of_workers           = optional(number)
    http2_enabled               = optional(bool)
    ip_restriction              = optional(list(string))
    scm_use_main_ip_restriction = optional(bool)
    scm_ip_restriction          = optional(list(string))
    java_version                = optional(string)
    java_container              = optional(string)
    java_container_version      = optional(string)
    local_mysql_enabled         = optional(bool)
    linux_fx_version            = optional(string)
    windows_fx_version          = optional(string)
    managed_pipeline_mode       = optional(string)
    min_tls_version             = optional(string)
    php_version                 = optional(string)
    python_version              = optional(string)
    remote_debugging_enabled    = optional(bool)
    scm_type                    = optional(string)
    use_32_bit_worker_process   = optional(bool)
    vnet_route_all_enabled      = optional(bool)
    websockets_enabled          = optional(bool)
  })
  default = null
}

variable "source_control" {
  type = object({
    repo_url           = optional(string)
    branch             = optional(string)
    manual_integration = optional(bool)
    rollback_enabled   = optional(bool)
    use_mercurial      = optional(bool)
  })
  default = null
}