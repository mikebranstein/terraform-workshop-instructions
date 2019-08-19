## Getting Started with Terraform

In this chapter, you'll deploy five services in Azure which will make up the base of your web application infrastructure: a Resource Group, an App Service Plan, an App Service, and a SQL Managed Instance Database (made up of a SQL Server resource and a SQL DB resource).

### Terraform Providers

In this seciton, youwe're going to start our Teraform code by creating our first code file and adding a provider.

> **What is a provider?**
>
> Providers tell Terraform what API it is interacting with for resource deployment. There are a number of officially supported Providers, as well as community-driven providers. The AzureRM Provider is one of the officially supported providers for Azure and the one we will be using throughout this workshop.

Let's jump right in.

<h4 class="exercise-start">
    <b>Exercise</b>: Getting started
</h4>

Before we get started, let's create a folder to work out of. On your VM, create a folder in the root fo the C drive named `terraform`. We'll be working from this folder throughout the workshop.

Next, open Visual Studio Code, open the `terraform` folder you created, then create a new file. We are going to name this file "main.tf". This is one of the standard file names used in Terraform. We will talk about the others later in the workshop.

> **What is a main.tf file?**
>
> The *main.tf* file is where we will delcare our instructions to Azure for what infrastructure we want to deploy and how we want to deploy the infrastructure. 

The first thing we need to do is tell Terraform to use the Azure RM Provider. 

Copy and paste the below section to the top of your main.tf file:

```
provider "azurerm" {
    tenant_id       = ""
    subscription_id = ""
    use_msi = true
}
```

Make sure to place your Azure Tenant and Subscription ID inside the quotes next to the appropriate parameter.

> **Where do I find my Tenant and Subscription IDs?**
>
> If you're unfamiliar with Azure, you may be wondering where to find these values. Check out the quick video below on where to find these values.

<img src="images/chapter2/ids.gif" class="img-override" />

Note - your Tenant ID is the Azure Active Directory Directory ID.

This concludes the exercise.

<div class="exercise-end"></div>

### Declaring Resources

Terraform is a declarative language, menaing it describes an intended goal (or end-state) of an environment, rather than the steps to reach the goal (or end-state).

This means that when your Terraform code is executed, Terraform will dynamically determine the steps it needs to take to bring your target environment in-line with your code. For example, assume your code declares a virtual machine. When run against an environment where the virtual machine does not exist, Terraform will create that virtual machine. If it's run against an environment where the virtual mahcine already exists, it will either update the virtual machine (so it's configured according to your definition) or do nothing (because the virtual machine needs no changes).

Declarative infra-as-code (IaC) languages can be powerful, but sometimes the results an be unexpected if you don't understand how/why they work. We're not going to get into the debate topic right now, but it wouldn't take you long to search for the different viewpoints online.

Enough talking - let's get declaring!

<h4 class="exercise-start">
    <b>Exercise</b>: Declaring resources
</h4>

Now that we have established the Provider, we can begin declaring resources. Resources are always declared in the same way. We start with what resource we want to deploy, the alias name for the resource, and the parameters required to deploy the resource.

For example:

```
resource "azurerm_resource_group" "my_resource_alias" {
  # key-value parameter pairs go here
  key1 = value1
  key2 = value2
}
```

Let's start by declaring an Azure resource group. 

> **Resource Groups** 
>
> Formally, resource groups provide a way to monitor, control access, provision and manage billing for collections of assets that are required to run an application, or used by a client or company department. Informally, think of resource groups like a file system folder, but instead of holding files and other folders, resource groups hold azure objects like storage accounts, web apps, functions, etc.

Copy and paste the below section to create a new resource group:

```
#Resource Group
resource "azurerm_resource_group" "application_rg" {
    name     = "tf-az-app1-dev-rg"
    location = "East US"
}
```

This resource only requires two parameters: a name and location. 

> **Aren't there more parameters?**
>
> If you're familiar with Azure, you may be thinking there are a bunch of other optional parameters you could provide for a resource group. You're right. There are additional parameters which are accepted by Terraform if we wanted to configure aspects like resource tags, etc. For this workshop you'll be filling in required parameters only. If you want to see the full list of parameters available for a resource, click on the highlighted resource name "azurerm_resource_group" in your VS Code main.tf file, or check out the options [here](https://www.terraform.io/docs/providers/azurerm/r/resource_group.html). 

> **What's in the Azure RM Provider?**
>
> There are a ton of resources you can declare using the AzureRM resource provider - too many to review here. Take a look at the [online documentation](https://www.terraform.io/docs/providers/azurerm/index.html) to see a comprehensive list. You'll also be able to see required and optional parameters for each resoruce type.

#### Declaring an App Service Plan

Next, we are going to add the App Service Plan. Add the following code below the resource group resource in main.tf:

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

When parameters of a resource have multiple/sub-parameters, they are encapsulated with {}. If you're familiar with JSON, this shouldn't look too strange. In this case, the App Service Plan has a multi-property parameter for the sku tier and sku size.

> **Whoa...dot-notation in Terraform?!**
>
> You may have noticed the ${} syntax with resource names and dot-notation in the above syntax. If you're familiar with programming languages, this won't surprise you. Terraform allows you to reference other declared resources by wrapping them in ${}, and using dot-notation to drill into properties of that resource. This comes in handy when you're chaining resources together, or when one resource depends on another resource. 
 
Looking back at the App Service Plan you jsut created, notice the "location" and "resource_group_name" properties. We used the dot-notation to obtain their values. We can pull other properties from other declared resources using the syntax "azurerm_<resource_type>.<resource_alias>.". In this case the resource type is "resource_group", the resource alias is "application_rg" (We provided the resource alias in the previous code snippet next to the declaration of the resource type), and the property we care about for location is ".location" and for resource_group_name it's ".name".

Now that we have declared the Plan our Application Service will use, let's create the Azure Web App. Use the following code and add it to your main.tf file:

```
resource "azurerm_app_service" "app1_app_service" {
    name = "tf-az-app1-dev-app"
    location = "East US"
    resource_group_name = "${azurerm_resource_group.application_rg.name}"
    app_service_plan_id = "${azurerm_app_service_plan.standard_app_plan.id}"
}
```

> **A few words on naming conventions**
>
> The standard naming convention in Terraform is to keep everything lowercase and separate key words by dashes. In addition to Terraform's standards, we have established here a pattern for naming resources in Azure. This pattern is a common best practice for Azure and can vary for each organization based on naming needs. The pattern above is as follows: "tf" to declare the resource was created by Terraform, "az" to denote this is an Azure resource (this comes in handy when in a hybrid scenario), "app1" is the application name, "dev" is the environment, and "app" is the shorthand chosen for the resource type. 

> **WARNING: Watch out for platform limitations when naming resources**
>
> In some cases, you cannot use dashes in names of Azure resources (ex. Storage Account) so an alternative is to keep everything lowercase and have no separation of key words with dashes if you want to keep names uniform across the board.
>
> Some resources must also have globally unique names (like Storage Accounts...again), so you may need adjust names accordingly.

#### Adding a SQL Server

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

resource "azurerm_sql_firewall_rule" "test" {
  name                = "tf-az-app1-allow-azure-sqlfw"
  resource_group_name = "${azurerm_resource_group.application_rg.name}"
  server_name         = "${azurerm_sql_server.standard_sql_server.name}"
  start_ip_address    = "0.0.0.0" # tells Azure to allow Azure services
  end_ip_address      = "0.0.0.0" # tells Azure to allow Azure serivces
}
```

The first declaration creates an Azure SQL Server, the second creates a database, and the third enables other Azure services (like Web Apps) to talk to the SQL Server.

This concludes the exercise.

<div class="exercise-end"></div>

The keen eye may have noticed we declared the Terraform resources in a specific order. Was that necesary? No. 

Terraform is smart, and when it runs against your declarative code, it reads the entire code file in, parses it, determines resource dependencies, and then creates/updates the infra in the order determined by it's dependency calculations. 

In other words, we could have added these resource code snippets in ANY order in the file, and Terraform will figure out the right way to order resources for proper deployment.

### Deploying resources with Terraform

Now that we have the "main.tf" file ready to go, let's deploy the resources.

<h4 class="exercise-start">
    <b>Exercise</b>: Deploying with Terraform
</h4>

Within Visual Studio Code, open a Terminal. Click "Terminal > New Terminal", then hit Enter.

In the terminal, navigate to the C:\terraform folder, where you created the main.tf file. 

```
cd c:\terraform 
```

Initialize Terraform:

```bash 
terraform init
```

> **What does initialization do?**
>
> The terraform init command is used to initialize a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.
>
> Behind the scenes, terraform init downloads any needed providers (like the AzureRM provider) when run, and ensures your code can run.

You can see the effects of running terraform init from within VS Code: a `.terraform` folder is created, containing the AzureRM provider for your operating system:

<img src="images/chapter2/init.png" class="img-small" />

Next, let's see what our terraform will create. Run the Terraform plan command:

```bash
terraform plan
```

The terraform plan command is used to create an execution plan. Terraform performs a refresh, unless explicitly disabled, and then determines what actions are necessary to achieve the desired state specified in the configuration files.

This command is a convenient way to check whether the execution plan for a set of changes matches your expectations without making any changes to real resources or to the state. For example, terraform plan might be run before committing a change to version control, to create confidence that it will behave as expected. You may also use terraform plan and save the output as part of an apporval process before making the changes permanent.

Finally, use Terraform to make the changes to your environment. Run terraform apply. When prompted, type 'yes' to confirm you want to deploy the resources.

```bash
terraform apply
```

The resources will deploy to your Azure subscription exactly as written. 

<img src="images/chapter2/apply.png" class="img-override" />

#### Checking your deployment

Open the Azure Portal (https://portal.azure.com) and look for the resource group you created. Find the app service you deployed and click into the resource. On the main overview page you can findthe default URL of the application service. Click on this link. 

You now have a base web application infrastructure where code can be deployed. Congrats! 

This concludes the exercise.

<div class="exercise-end"></div>

In the next chapter, we'll talk about how we can reformat this basic configuration file to be re-usable.