## Getting Started with Terraform

In this section, we are going to deploy five services in Azure which will make up the base of our web application infrastructure: a Resource Group, an Application Service Plan, an Application Service, and a SQL Managed Instance Database (made up of a SQL Server resource and a SQL DB resource).

First, let's open up Visual Studio Code and create a new file. We are going to name this file "main.tf". This is one of the standard file names used in Terraform. We will talk about the others later in the workshop.

The "main.tf" file is where we will delcare our instructions to Azure for what infrastructure we want to deploy and how we want to deploy the infrastructure.

The first thing we need to do is tell Terraform to use the Azure RM Provider. The Provider tells Terraform what API it is interacting with for resource deployment. There are a number of officially supported Providers, as well as community-driven providers. The AzureRM Provider is one of the officially supported providers for Azure and the one we will be using throughout this workshop.

Copy and paste the below section to the top of your main.tf file:

```
provider "azurerm" {
    tenant_id       = ""
    subscription_id = ""
    use_msi = true
}
```

Make sure to place your Azure Tenant and Subscription ID inside the quotes next to the appropriate parameter.

Now that we have established the Provider, we can begin declaring resources. Resources are always declared in the same way. We start with what resource we want to deploy, the alias name for the resource, and the parameters required to deploy the resource.

Copy and paste the below section to create a new resource group:

```
#Resource Group
resource "azurerm_resource_group" "application_rg" {
    name     = "tf-az-app1-dev-rg"
    location = "East US"
}
```

This resource only requires two parameters, which we have filled in here. There are additional parameters which are accepted by Terraform if we wanted to configure aspects like Tagging, etc. For this lab we will only be filling in required parameters. If you want to see the full list of parameters available for a resource, click on the highlighted resource name "azurerm_resource_group" in your VS Code main.tf file.

Next, we are going to add the Application Service Plan by pasting the following code below the resource group resource:

```
resource "azurerm_app_service_plan" "standard_app_plan" {
    name = "tf-standard-plan"
    location = "${azurerm_resource_group.application_rg.location}"
    resource_group_name = "${azurerm_resource_group.application_rg.name}"
    sku {
        tier = "Basic"
        size = "B1"
    }
}
```
When parameters of a resource have multiple/sub-parameters, they are encapsulated with {}. In this case, the app service plan has a multi-property parameter for the sku tier and sku size.

Also, notice the "location" and "resource_group_name" properties are using built-in syntax to obtain their values. We can pull outputs from other declared resources using the syntax "azurerm_<resource_type>.<resource_alias>.". In this case the resource type is "resource_group", the resource alias is "application_rg" (We provided the resource alias in the previous code snippet next to the declaration of the resource type), and the property we care about for location is ".location" and for resource_group_name it's ".name".

Now that we have declared the Plan our Application Service will use, we need to create the Azure Web App. Use the following code:

```
resource "azurerm_app_service" "app1_app_service" {
    name = "tf-az-app1-dev-app"
    location = "East US"
    resource_group_name = "${azurerm_resource_group.application_rg.name}"
    app_service_plan_id = "${azurerm_app_service_plan.app_plan.id}"
}
```

The standard naming convention in Terraform is to keep everything lowercase and separate key words by dashes. In addition to Terraform's standards, we have established here a pattern for naming resources in Azure. This pattern is a common best practice for Azure and can vary for each organization based on naming needs. The pattern above is as follows: "tf" to declare the resource was created by Terraform, "az" to denote this is an Azure resource (this comes in handy when in a hybrid scenario), "app1" is the application name, "dev" is the environment, and "app" is the shorthand chosen for the resource type. 

In some cases, you cannot use dashes in names of Azure resources (ex. Storage Account) so an alternative is to keep everything lowercase and have no separation of key words with dashes if you want to keep names uniform across the board.

Last, let's deploy a SQL Managed Instance DB. Use this code:

```
resource "azurerm_sql_server" "standard_sql_server" {
  name                         = "tf-az-standard-sql-dev"
  resource_group_name          = "${azurerm_resource_group.application_rg.name}"
  location                     = "East US"
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "CodePalousa2019!"
}

resource "azurerm_sql_database" "app1_db" {
  name                = "tf-az-app1-dev-db"
  resource_group_name = "${azurerm_resource_group.application_rg.name}"
  location            = "East US"
  server_name         = "${azurerm_sql_server.standard_sql_server.name}"
}
```

One last note about the configuration file we just created: while we are placing resources in a logical order, Terraform is a declarative language. This means we could have added these resource code snippets in ANY order in the file. Terraform will figure out the right way to order resources for proper deployment.

Now that we have the "main.tf" file ready to go, let's deploy the resources.

1. Click "Terminal > New Terminal", then hit Enter.
2. We need to make sure we are in the same folder where we created the main.tf file. Run cd ./<folder path> to move into the folder's directory.
3. Login to Azure by typing az login and supplying your credentials.
4. Type terraform init and press enter. This tells Terraform to initialize the configuration files in this folder.
5. Next, let's see what our terraform will create. Type terraform plan and press enter.

If the code was written successfully, this should produce a list of all the resources terraform will create in Azure with values (or computed values) supplied. This is a way for us to check what we are deploying and make sure it is right before we actually deploy the resources to Azure.

6. Type terraform apply and press enter. When prompted, type 'yes' to confirm you want to deploy the resources.

The resources will deploy to your Azure subscription exactly as written. Open up the Azure Portal (https://portal.azure.com) and look for the resource group you created. Find the app service you deployed and click into the resource. On the main overview page you can findthe default URL of the application service. Click on this link. 

You now have a base web application infrastructure where code can be deployed. Congrats! 

In the next module, we'll talk about how we can reformat this basic configuration file to be re-usable.