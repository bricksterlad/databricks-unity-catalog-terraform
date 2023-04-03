variable "service_principals" {
  type = map(object({
    sp_id       = string
    permissions = list(string)
  }))
  default     = {}
  description = "list of service principals we want to create at Databricks account"
}

variable "workspace_id" {
  type        = string
  description = "the workspace id to which we want to assign the service principal"
}
