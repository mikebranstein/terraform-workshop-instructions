provider "azurerm" {
    tenant_id       = "" #Update for testing
    subscription_id = "" #Update for testing
    #use_msi = true
}

terraform {
    backend "azurerm" {
        storage_account_name = "abcd1234" #Update for testing
        container_name       = "tfstate" #Update for testing
        key                  = "prod.terraform.tfstate" #Update for testing
        use_msi              = true
        subscription_id      = "00000000-0000-0000-0000-000000000000" #Update for testing
        tenant_id            = "00000000-0000-0000-0000-000000000000" #Update for testing
    }
}

module "core_services" {
    source                        = "../_modules/core_services/"

    environment                   = "dev"
    functional_name               = "core-services"
    location                      = "East US"
    virtual_network_address_space = "10.10.0.0/16"
    management_subnet             = "10.10.1.0/24" 
    gateway_subnet                = "10.10.2.0/24"
    application_name              = "app1"
    
}

module "standard_application" {
    source                     = "../_modules/standard_application/"

    environment                = "dev"
    application_name           = "app1"
    location                   = "East US"
    application_plan_tier      = "Basic"
    application_plan           = "B1"
    sql_administrator_login    = "sqladmin"
    sql_administrator_password = "SQLP@ss123"
}

module "shared_services" {
    source            = "../_modules/shared_services/"

    environment       = "dev"
    functional_name   = "shared-services"
    location          = "East US"
    application_name  = "app1"
    gateway_subnet_id = "${module.core_services.gateway_subnet_id}"
    app_service_fqdn  = "${module.standard_application.app_service_fqdn}"
}      