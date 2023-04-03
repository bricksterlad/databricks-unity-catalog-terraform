variable "access_connector_id" {
  type        = string
  description = "The id of the access connector that will be assumed by Unity Catalog to access data"
}

variable "metastore_storage_name" {
  type        = string
  description = "the account storage where we create the metastore"
}

variable "metastore_name" {
  type        = string
  description = "the name of the metastore"
}

variable "service_principals" {
  type = map(object({
    sp_id        = string
    display_name = string
  }))
  default     = {}
  description = "list of service principals we want to create at Databricks account"
}

variable "access_connector_name" {
  type        = string
  description = "the name of the access connector"
}
