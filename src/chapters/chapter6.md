##Securing the Web Application with a WAF/Application Gateway

In this chapter, we will be extending our existing web application infrastructure to include a layer of networking and security. We will be adding two new modules which will be integrated into what has already been deployed. This includes an Azure Application Gateway resource.

>**What is a WAF/App Gateway?**
>
>An Azure Application Gateway is a managed Layer 7 Firewall service provided by Microsoft. This solution is sometimes referred to as a WAF or Web Application Firewall, and in fact, has a WAF mode which includes additional features such as protection against SQL Injections. The App Gateway is a powerful tool which gives us URL routing capabilities, and enterprise level network security and can integrate with other Azure services, including Azure Web Apps.

###Create Supporting Modules

In addition to the Application Gateway, we have some other network resources which will be deployed. This includes an Azure Virtual Network, Subnets, and a Public IP which will be used for the Application Gateway. 

>**Virtual Networks, Subnets, Public IPs**
>
>The Virtual Network is a unique address space which contains one or more subnets and can be used for internal, isolated routing. Some PaaS services in Azure can be integrated with Virtual Networks, including App Services. Subnets are a way to carve up the address space and further isolate resources on the private network. Public IPs are resources in Azure which can be attached to services like the Application Gateway to provide a single entrypoint for web applications.

#### The Core Services
Let's get on with creating our modules! The first module we are going to create is for the Virtual Network and Subnets. This module will be called "core_services" and will be separated into it's own Resource Group.

Start by creating a folder in C:\Terraform\_modules called "core_services". Next, create the three standard Terraform files: "main.tf", "variables.tf", and "output.tf".

Open the "core_services\variables.tf" file and paste the following code:

```
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
```

Nothing too new here, this just establishes the variables we plan to use for the module. Notice the management_subnet and gateway_subnet variables. This will allow users to pass in a CIDR address space (ex. 10.10.0.0/16) to define a subnet. There are ways to dynamically generate subnets using built-in Terraform functions, but we won't be diving into that in this workshop.

Next, let's populate our main.tf file with resources. Copy and paste the following code into your "core_services\main.tf" file:

```
#Resource Group
resource "azurerm_resource_group" "network_rg" {
    name     = "tf-az-${var.functional_name}-${var.environment}-rg"
    location = "${var.location}"
}

#Virtual Network
resource "azurerm_virtual_network" "core_vnet" {
    name                = "tf-az-${var.functional_name}--${var.environment}-vnet"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.network_rg.name}"
    address_space       = ["${var.virtual_network_address_space}"]
}

#Subnets
resource "azurerm_subnet" "management_subnet" {
    name                 = "tf-az-${var.functional_name}-mgmt-subnet"
    address_prefix       = "${var.management_subnet}"
    virtual_network_name = "${azurerm_virtual_network.core_vnet.name}"
    resource_group_name  = "${azurerm_resource_group.network_rg.name}"
}

resource "azurerm_subnet" "gateway_subnet" {
    name                 = "tf-az-${var.functional_name}-gw-subnet"
    address_prefix       = "${var.gateway_subnet}"
    virtual_network_name = "${azurerm_virtual_network.core_vnet.name}"
    resource_group_name  = "${azurerm_resource_group.network_rg.name}"
}
```

We have created a new Resource Group, a Virtual Network, and two Subnets. Take note of the address_space parameter in the virtual network resource. The [] are required because the address_space parameter expects a list. Lists are declared with [] in Terraform. This means we could pass in more than one comma-separated address space if we wanted.

The management subnet is a standard subnet generally used for operations resources. The gateway subnet will be used for the Application Gateway.

We are almost done with this module. We need to add an output. Open the "core_services\output.tf" file and paste the following code:

```
output "gateway_subnet_id" {
   value = "${azurerm_subnet.gateway_subnet.id}"
}
```

This output will be used to pass the gateway subnet id from this module to the next module we will create. We are doing this because the next module includes our Application Gateway, and one of the required parameters is the subnet id for gateway configuration.

#### The Shared Services

The next module we will create is the shared services module. This is where our Application Gateway resides, and is theoretically the place where all services which are shared between multiple applications should reside. Or rather, services which have a shared level of management between teams. Arguably we could have App Service Plans and SQL Server resources here since they could be shared between multiple applications but we prefer to keep these co-located with the applications they support, as they will generally be managed by the same teams.

Create a folder under _modules called "shared_services" and create the three Terraform files: "main.tf", "variables.tf", and "output.tf".

Open the "shared_services\variables.tf" file and paste the following code:

```
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
```

The gateway_subnet_id and the app_service_fqdn variables from above will be populated with the outputs from the core_services and standard_application modules. Way back in chapter three we created an output in our standard_application module called "app_service_fqdn" which retrieves the App Service FQDN for use with our Application Gateway. Likewise, the gateway_subnet_id will be passed from the output we created earlier in this chapter for use in the App Gateway resource. We'll talk more about how we pass in those outputs later.

Let's populate our "shared_services\main.tf" file with all the resources we need:

```
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
```

As you can see from the above code, the Application Gateway is a fairly complicated resource. The first four sub-property blocks create the core components of the Application Gateway: sku, gateway_ip_configuration, frontend_port, frontend_ip_configuration. The next four sub-property blocks are tied to specific application pools (in our case, the single web application): backend_address_pool, backend_http_settings, http_listener, request_routing_rule. If we had multiple application back-ends this Application Gateway talked to, we would need to include those four sub-property blocks AGAIN for that application. This means the Application Gateway resource can grow exponentially in a configuration file and is the primary reason we have split this resource out into its own module.

Notice the gateway_ip_configuration includes our gateway_subnet_id variable which will be populated with our output from the "core_services" module. The backend_address_pool includes our app_service_fqdn variable which will be populated with our output from the "standard_application" module.

We are not going to add any outputs in the shared_services module but we want the file to exist so that if we later decide we need information from this module we can update the module to include those outputs.

### Putting it all together

Now that we have created our modules, we need to tie them together in a single deployment. We will do this from the dev\main.tf file we created in a previous chapter.

Open the "C:\Terraform\dev\main.tf" file.

Below the backend "azurerm" {} code block paste the following code:

```
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
```

This will create our core services. The Virtual Network will be created with a /16 address space and be carved up into two /24 subnets.

Next, we will add the following code after the module "standard_application" {} block:

```
module "shared_services" {
    source            = "../_modules/shared_services/"

    environment       = "dev"
    functional_name   = "shared-services"
    location          = "East US"
    application_name  = "app1"
    gateway_subnet_id = "${module.core_services.gateway_subnet_id}"
    app_service_fqdn  = "${module.standard_application.app_service_fqdn}"
}  
```

>**A reminder on Ordering**
>
>If you don't put these in the right order... that's okay! This is a declarative language. However, for ease of reading and logical ordering we are placing things in a specific order.

Notice the gateway_subnet_id and the app_service_fqdn variables are retrieving values from the other modules. Terraform will wait for those modules to complete before attempting to start deployment of the shared_services module. Module outputs can be retrieved using ${module.<module name>.<output name>}. If no output is defined, the values cannot be retrieved directly from the module.

### Deploying to Dev and Prod

With all the modules declared, we can now fully deploy our development environment. This time, we do not have to delete the previously created resources. This is because we have a state file from our previous module which will tell Terraform that one of the modules has already been deployed. Terraform will read the state file, verify the configurations match, then move on to deploying the new modules.

In our Terminal window, navigate to "C:\Terraform\dev", then paste the following command:

```bash
terraform plan
```

Once we have confirmed everything will deploy as expected, go ahead and run the apply:

```bash
terraform apply
```

Type 'yes' to confirm the deployment. The resources will deploy to your Azure subscription exactly as written.

Next, let's copy our dev\main.tf file over to the prod folder. Once in the prod folder, go ahead and change the environment parameters values to "prod" (make sure to change this for each module called).

We can leave everything else the same. The ip addresses of the virtual network for production will overlap BUT the virtual networks are not connected with each other. So this will not cause any issues. In a real world scenario, the ip address spaces would likely be different even though they still probably wouldn't be connected to each other for the sake of resource isolation.

Now that you have the prod\main.tf file updated, open the terminal and cd to C:\Terraform\prod, then paste the following command:

```bash
terraform plan
```

Once we have confirmed everything will deploy as expected, go ahead and run the apply:

```bash
terraform apply
```

When complete, you will now have two sets of environments deployed in your Azure Subscription, one for Development and one for Production.

###Wrap up
Let's test our application...

Congrats! You now have a functioning, secure web application using infrastructure as code with Terraform!