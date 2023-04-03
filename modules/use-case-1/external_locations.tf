resource "databricks_external_location" "landing-external-location" {
  name            = var.landing_external_location_name
  url             = var.landing_adls_path
  credential_name = var.storage_credential_id
}

resource "databricks_external_location" "checkpoint-external-location" {
  name            = var.checkpoint_external_location_name
  url             = var.checkpoint_adls_path
  credential_name = var.storage_credential_id
}
