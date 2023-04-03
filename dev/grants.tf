resource "databricks_grants" "landing-external-location-grants" {
  depends_on        = [module.usecase1-unity-catalog-resources]
  external_location = "landing_external_location_${var.environment}"
  dynamic "grant" {
    for_each = toset(local.metastore_admins)
    content {
      principal  = grant.key
      privileges = ["READ_FILES", "WRITE_FILES"]
    }
  }
  grant {
    principal  = "data_engineer_group"
    privileges = ["READ_FILES", "WRITE_FILES"]
  }
  provider = databricks.workspace
}

resource "databricks_grants" "catalog_bronze-grants" {
  depends_on = [module.usecase1-unity-catalog-resources]
  catalog    = "catalog_${var.environment}_${var.bronze_layer}"
  dynamic "grant" {
    for_each = toset(local.metastore_admins)
    content {
      principal = grant.key
      privileges = ["USE_CATALOG", "USE_SCHEMA", "SELECT", "EXECUTE", "CREATE_SCHEMA",
        "CREATE_FUNCTION", "CREATE_TABLE", "CREATE_VIEW", "MODIFY"]
    }
  }
  grant {
    principal = "data_engineer_group"
    privileges = ["USE_CATALOG", "USE_SCHEMA", "SELECT", "EXECUTE",
      "CREATE_FUNCTION", "CREATE_TABLE", "CREATE_VIEW", "MODIFY"]
  }
  provider = databricks.workspace
}