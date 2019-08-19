output "app_service_fqdn" {
    value = "${azurerm_app_service.app1_app_service.default_site_hostname}"
}