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

variable "workspace_id" {
  type        = string
  description = "the workspace id to which we want to assign the service principal"
}
