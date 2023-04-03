module "unity-catalog-metastore" {
  source                 = "../modules/unity-catalog-metastore"
  access_connector_id    = var.access_connector_id
  metastore_storage_name = var.metastore_storage_name
  metastore_name         = var.metastore_name
  access_connector_name  = var.access_connector_name
  providers = {
    databricks = databricks.workspace
  }
}


module "account-service-principals" {
  source             = "../modules/service-principals"
  service_principals = var.service_principals
  providers = {
    databricks = databricks.account
  }
}

