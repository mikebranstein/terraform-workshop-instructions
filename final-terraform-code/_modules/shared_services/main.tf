#Resource Group
resource "azurerm_resource_group" "shared_rg" {
    name     = "tf-az-${var.functional_name}-${var.environment}-rg"
    location = "${var.location}"
}

#Public IP Address
resource "azurerm_public_ip" "gateway_pip" {
    name                = "tf-az-${var.functional_name}--${var.environment}-pip"
    resource_group_name = "${azurerm_resource_group.shared_rg.name}"
    location            = "${var.location}"
    sku                 = "Standard"
    allocation_method   = "Static"
}

#Application Gateway
resource "azurerm_application_gateway" "gateway" {
    name     = "tf-az-${var.functional_name}--${var.environment}-ag"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.shared_rg}"
 
    sku {
        name     = "Standard_Medium"
        tier     = "WAF_v2"
        capacity = 1
    }

    gateway_ip_configuration {
        name      = "tf-az-${var.functional_name}-ip-configuration"
        subnet_id = "${var.gateway_subnet_id}"
    }

    frontend_port {
        name = "tf-az-${var.functional_name}-fep-80"
        port = 80
    }

    frontend_ip_configuration {
        name                 = "tf-az-${var.functional_name}-feip"
        public_ip_address_id = "${azurerm_public_ip.test.id}"
    }

    backend_address_pool {
        name = "tf-az-${var.application_name}-beap"
        fqdns = ["${var.app_service_fqdn}"]
    }

    backend_http_settings {
        name                  = "tf-az-${var.application_name}-http-80"
        cookie_based_affinity = "Disabled"
        path                  = "/"
        port                  = 80
        protocol              = "Http"
        request_timeout       = 20
    }

    http_listener {
        name                           = "tf-az-${var.application_name}-listener"
        frontend_ip_configuration_name = "tf-az-${var.application_name}-feip"
        frontend_port_name             = "tf-az-${var.application_name}-fep-80"
        protocol                       = "Http"
    }

    request_routing_rule {
        name                        = "tf-az-${var.application_name}-rule"
        rule_type                   = "Basic"
        http_listener_name          = "tf-az-${var.application_name}-listener"
        backend_address_pool_name   = "tf-az-${var.application_name}-beap"
        backend_http_settings_name  = "tf-az-${var.application_name}-http-80"
    }
}
