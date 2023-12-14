resource "azurerm_container_app_environment" "terraformed" {
  name                       = "cae-${local.stack}"
  location                   = azurerm_resource_group.lab4.location
  resource_group_name        = azurerm_resource_group.lab4.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.lab4-log.id

  tags = local.default_tags
}

resource "azurerm_container_app" "spring-app-container" {
  name = "ca-${local.stack}"

  container_app_environment_id = azurerm_container_app_environment.terraformed.id
  resource_group_name          = azurerm_resource_group.lab4.name
  revision_mode                = "Single"


  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 8080
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }

  }

  template {
    container {
      name   = "javka"
      image  = "docker.io/grimlord16/docker-cluds:latest"
      cpu    = 1
      memory = "2Gi"

      env {
        name  = "DB_CONNECT"
        value = var.SQL_CONSTR
      }
    }

    http_scale_rule {
      name                = "http-rule"
      concurrent_requests = 50
    }
    min_replicas = 1
    max_replicas = 10
  }
}

resource "azurerm_container_app" "lab4-tests" {
  name = "ca-${local.stack}-tests"

  container_app_environment_id = azurerm_container_app_environment.terraformed.id
  resource_group_name          = azurerm_resource_group.lab4.name
  revision_mode                = "Single"

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 8089
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }

  }

  template {
    container {
      name   = "javka-tests"
      image  = "docker.io/grimlord16/locust-image:latest"
      cpu    = 1
      memory = "2Gi"
    }
    min_replicas = 1
    max_replicas = 5
  }

}