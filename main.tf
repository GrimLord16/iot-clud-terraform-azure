locals {
  stack = "${var.app}-${var.env}-${var.location}"

  default_tags = {
    environment = var.env
    owner       = "Grim"
    app         = var.app
  }

}

resource "azurerm_resource_group" "lab4" {
  name     = "rg-${local.stack}"
  location = var.region

  tags = local.default_tags
}

resource "azurerm_log_analytics_workspace" "lab4-log" {
  name                = "log-${local.stack}"
  location            = azurerm_resource_group.lab4.location
  resource_group_name = azurerm_resource_group.lab4.name

  tags = local.default_tags
}