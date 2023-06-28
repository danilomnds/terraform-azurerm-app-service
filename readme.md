# Module - App Service (Under Construction)
[![COE](https://img.shields.io/badge/Created%20By-CCoE-blue)]()
[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

Module developed to standardize the creation of Azure App Services

## Compatibility Matrix

| Module Version | Terraform Version | AzureRM Version |
|----------------|-------------------| --------------- |
| v1.0.0         | v1.4.6            | 3.57.0          |

## Specifying a version

To avoid that your code get updates automatically, is mandatory to set the version using the `source` option. 
By defining the `?ref=***` in the the URL, you can define the version of the module.

Note: The `?ref=***` refers a tag on the git module repo.

## Use case

```hcl
module "<app-service-name>" {
  source                       = "git::https://github.com/danilomnds/terraform-azurerm-app-service?ref=v1.0.0"
  name                         = <app-service-name>
  location                     = <region>
  resource_group_name          = <resource-group-name>
  kind                         = "Windows"
  maximum_elastic_worker_count = <1>
  sku = {    
    tier                       = "<Standard>",
    size                       = "<S1>"
    capacity                   = "<2>"    
  }
  tags = {
    "key1"                     = "value1"
    "key2"                     = "value2"
  }
  
}
output "app_service_plan_id" {
  value = module.app-service-name.id
}
```

## Input variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| plan_name | app service plan name | `string` | n/a | No |
| name | app service name | `string` | n/a | `Yes` |
| resource_group_name | resource group where the ACR will be placed | `string` | n/a | `Yes` |
| location | azure region | `string` | n/a | `Yes` |
| kind | the kind of the app service plan to create | `string` | `Windows` | No |
| maximum_elastic_worker_count | the maximum number of total workers allowed for this elasticscaleenabled app service plan | `number` | `null` | No |
| sku | block as documented below | `object({})` | `null` | No |
| identity | block for custom the configuration of managed identity  | `object({})` | n/a | `Yes` |
| app_service_environment_id | The ID of the App Service Environment where the App Service Plan should be located | `string` | `null` | No |
| reserved `to be confirmed`| is this app service plan | `bool` | `false` | No |
| per_site_scaling `to be confirmed`| can apps assigned to this app service plan be scaled independently | `bool` | `false` | No |
| is_xenon `to be confirmed`| whether to create a xenon app service plan | `bool` | `false` | No |
| zone_redundant `to be confirmed`| specifies if the app service plan should be zone redundant | `bool` | `false` | No |
| tags | tags for the resource | `map(string)` | `{}` | No |


## Objects and map variables list of acceptable parameters
| Variable Name (Block) | Parameter | Description | Type | Default | Required |
|-----------------------|-----------|-------------|------|---------|:--------:|
| sku | tier | Specifies the plan's pricing tier | `string` | n/a | `Yes` |
| sku | size | Specifies the plan's instance size | `string` | n/a | `Yes` |
| sku | capacity | Specifies the number of workers associated with this App Service Plan | `string` | n/a | No |

## Output variables

| Name | Description |
|------|-------------|
| app_service_plan_id | app service plan id |


## Documentation
Terraform Azure App Service Plan: <br>
[https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_plan)