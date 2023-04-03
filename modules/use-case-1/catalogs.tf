resource "databricks_catalog" "bronze-catalog" {
  metastore_id  = var.metastore_id
  name          = "catalog_${var.environment}_${var.bronze_layer}"
  comment       = "this catalog is for the bronze layer in the ${var.environment} environment"
  force_destroy = false
}

resource "databricks_catalog" "silver-catalog" {
  metastore_id  = var.metastore_id
  name          = "catalog_${var.environment}_${var.silver_layer}"
  comment       = "this catalog is for the bronze layer in the ${var.environment} environment"
  force_destroy = false
}

resource "databricks_catalog" "gold-catalog" {
  metastore_id  = var.metastore_id
  name          = "gold_catalog_${var.environment}"
  comment       = "Gold catalog for the ${var.environment} environment"
  force_destroy = false
}
