provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id = "e2ab7ee3-6bcb-403e-84f0-02ce66ee2d10"
}