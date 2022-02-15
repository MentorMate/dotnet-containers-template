variable "client_id" {}
variable "client_secret" {}
variable "subscription_id" {}

variable "agent_count" {
    default = 3
}

variable "dns_prefix" {
    default = "calc-template"
}

variable cluster_name {
    default = "calc-template"
}

variable resource_group_name {
    default = "calc-template"
}

variable location {
    default = "West Europe"
}

variable log_analytics_workspace_name {
    default = "calcTemplateLogAnalyticsWorkspaceName"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
    default = "westeurope"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable log_analytics_workspace_sku {
    default = "PerGB2018"
}
