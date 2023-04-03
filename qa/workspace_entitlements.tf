data "databricks_group" "account_groups" {
  for_each     = var.account_groups
  display_name = each.value["group_name"]
  provider     = databricks.workspace
}

resource "databricks_entitlements" "workspace-groups" {
  for_each                   = var.account_groups
  group_id                   = data.databricks_group.account_groups[each.key].id
  allow_cluster_create       = each.value["has_allow_cluster_create"]
  allow_instance_pool_create = each.value["has_allow_instance_pool_create"]
  databricks_sql_access      = each.value["has_sql_access"]
  workspace_access           = each.value["has_workspace_access"]
  provider                   = databricks.workspace
}