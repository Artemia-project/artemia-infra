# Queue Properties for State Storage
resource "azurerm_storage_account_queue_properties" "state" {
  storage_account_id = azurerm_storage_account.state.id

  hour_metrics {
    version = "1.0"
  }

  logging {
    version = "1.0"
    delete  = false
    read    = false
    write   = false
  }

  minute_metrics {
    version = "1.0"
  }
}