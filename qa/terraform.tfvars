environment           = "qa"
workspace_id          = "<workspace_id>"
metastore_id          = "<metastore_id>"
bronze_layer          = "bronze"
silver_layer          = "silver"
gold_layer            = "gold"
storage_credential_id = "<storage_credential_id>"
service_principals = {
  "sp-data-pipeline" = {
    sp_id       = "sp_id"
    permissions = ["ADMIN"]
  }
}
account_groups = {
  "metastore_admin_group" = {
    group_name                     = "metastore_admin_group"
    permissions                    = ["USER"]
  }
  "data_engineer_group" = {
    group_name                     = "data_engineer_group"
    permissions                    = ["USER"]
  }
  "data_science_group" = {
    group_name                     = "data_science_group"
    permissions                    = ["USER"]
  }
  "machine_learning_group" = {
    group_name                     = "machine_learning_group"
    permissions                    = ["USER"]
  }
}