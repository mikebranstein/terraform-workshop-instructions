variable "functional_name" {
    description = "The primary purpose of the resources (ex. 'shared-services')"
}

variable "location" {
    description = "Location where Resources will be deployed"
}

variable "virtual_network_address_space" {
    description = "The Address Space of the Virtual Network"
}

variable "management_subnet" {
    description = "The Management Subnet (x.x.x.x/x)"
}

variable "gateway_subnet" {
    description = "The Gateway Subnet (x.x.x.x/x)"
}

variable "application_name" {
    description = "The Name of the Application"
}

variable "environment" {
    description = "Environment of all deployed resources"
}