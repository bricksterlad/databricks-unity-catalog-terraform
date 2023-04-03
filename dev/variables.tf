variable "environment" {
  type        = string
  description = "the deployment environment"
}

variable "metastore_id" {
  type        = string
  description = "Id of the metastore"
}

variable "workspace_id" {
  type        = string
  description = "Id of the workspace"
}

variable "bronze_layer" {
  type        = string
  description = "bronze layer"
}

variable "silver_layer" {
  type        = string
  description = "silver layer"
}

variable "gold_layer" {
  type        = string
  description = "gold layer"
}

variable "storage_credential_id" {
  type        = string
  description = "the storage credential id"
}

variable "service_principals" {
  type = map(object({
    sp_id       = string
    permissions = list(string)
  }))
  default     = {}
  description = "list of service principals we want to assign to the workspace"
}

variable "account_groups" {
  type = map(object({
    group_name                     = string
    permissions                    = list(string)
    has_allow_cluster_create       = bool
    has_allow_instance_pool_create = bool
    has_sql_access                 = bool
    has_workspace_access           = bool
  }))
  default     = {}
  description = "list of databricks account groups we want to assign to the workspace"
}

