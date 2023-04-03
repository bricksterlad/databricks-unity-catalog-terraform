resource "databricks_schema" "bronze_source1-schema" {
  depends_on    = [databricks_catalog.bronze-catalog]
  catalog_name  = databricks_catalog.bronze-catalog.name
  name          = "bronze_source1"
  force_destroy = true
}

resource "databricks_schema" "silver_source1-schema" {
  depends_on    = [databricks_catalog.silver-catalog]
  catalog_name  = databricks_catalog.silver-catalog.name
  name          = "silver_source1"
  force_destroy = true
}

resource "databricks_schema" "gold_usecase1-schema" {
  depends_on    = [databricks_catalog.gold-catalog]
  catalog_name  = databricks_catalog.gold-catalog.name
  name          = "gold_usecase1"
  force_destroy = true
}