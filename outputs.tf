output "azurerm_container_app_url" {
  value = azurerm_container_app.spring-app-container.latest_revision_fqdn
}