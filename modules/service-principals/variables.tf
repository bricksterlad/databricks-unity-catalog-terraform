variable "service_principals" {
  type = map(object({
    sp_id        = string
    display_name = string
  }))
  default     = {}
  description = "list of service principals we want to create at Databricks account"
}
