#Resource Group
resource "azurerm_resource_group" "application_rg" {
    name     = "tf-az-${var.application_name}-${var.environment}-rg"
    location = "${var.location}"
}

#Application Service Plan
resource "azurerm_app_service_plan" "standard_app_plan" {
    name = "tf-az-standard-plan"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.application_rg.name}"
    sku {
        tier = "${var.application_plan_tier}"
        size = "${var.application_plan_size}"
    }
}

#Application Service
resource "azurerm_app_service" "app1_app_service" {
    name = "tf-az-${var.application_name}-${var.environment}-app"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.application_rg.name}"
    app_service_plan_id = "${azurerm_app_service_plan.app_plan.id}"
}

#SQL Managed Instance DB
resource "azurerm_sql_server" "standard_sql_server" {
  name                         = "tf-az-standard-sql-${var.environment}"
  resource_group_name          = "${azurerm_resource_group.application_rg.name}"
  location                     = "${var.location}"
  version                      = "12.0"
  administrator_login          = "${var.sql_administrator_login}"
  administrator_login_password = "${var.sql_administrator_password}"
}

resource "azurerm_sql_database" "app1_db" {
  name                = "tf-az-${var.application_name}--${var.environment}-db"
  resource_group_name = "${azurerm_resource_group.application_rg.name}"
  location            = "${var.location}"
  server_name         = "${azurerm_sql_server.standard_sql_server.name}"
}