variable "environment" {
  type        = string
  description = "the deployment environment"
}

variable "metastore_id" {
  type        = string
  description = "Id of the metastore"
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

variable "landing_adls_path" {
  type        = string
  description = "The ADLS path of the landing zone"
}

variable "checkpoint_adls_path" {
  type        = string
  description = "The ADLS path of the checkpoint"
}

variable "landing_external_location_name" {
  type        = string
  description = "the name of the landing external location"
}

variable "checkpoint_external_location_name" {
  type        = string
  description = "The name of the checkpoint external location"
}
