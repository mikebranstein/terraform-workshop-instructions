variable "functional_name" {
    description = "The primary purpose of the resources (ex. 'shared-services')"
}

variable "location" {
    description = "Location where Resources will be deployed"
}

variable "gateway_subnet_id" {
    description = "The Gateway Subnet (x.x.x.x/x)"
}

variable "application_name" {
    description = "The Name of the Application"
}

variable "environment" {
    description = "Environment of all deployed resources"
}

variable "app_service_fqdn" {
    description = "The FQDN of the Application Service"
}