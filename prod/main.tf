module "metastore-workspace-assignments" {
  source             = "../modules/metastore-workspace-assignment"
  workspace_id       = var.workspace_id
  metastore_id = var.metastore_id
  providers = {
    databricks = databricks.account
  }
}

module "service-principals-workspace-assignments" {
  source             = "../modules/service-principals-workspace-assignments"
  workspace_id       = var.workspace_id
  service_principals = var.service_principals
  providers = {
    databricks = databricks.account
  }
}

module "groups-workspace-assignments" {
  source         = "../modules/groups-workspace-assignment"
  workspace_id   = var.workspace_id
  account_groups = var.account_groups
  providers = {
    databricks = databricks.account
  }
}

module "usecase1-unity-catalog-resources" {
  depends_on                        = [module.metastore-workspace-assignments, module.service-principals-workspace-assignments,
                                       module.groups-workspace-assignments]
  source                            = "../modules/use-case-1"
  workspace_id                      = var.workspace_id
  metastore_id                      = var.metastore_id
  environment                       = var.environment
  bronze_layer                      = var.bronze_layer
  silver_layer                      = var.silver_layer
  gold_layer                        = var.gold_layer
  storage_credential_id             = var.storage_credential_id
  landing_adls_path                 = "abfss://landing@<landingstorageaccount>${var.environment}.dfs.core.windows.net"
  checkpoint_adls_path              = "abfss://checkpoint@<checkpointstorageaccount>${var.environment}.dfs.core.windows.net/"
  landing_external_location_name    = "landing_external_location_${var.environment}"
  checkpoint_external_location_name = "checkpoint_external_location_${var.environment}"
  providers = {
    databricks = databricks.workspace
  }
}
