## Create a Terraform Module

In this section we are going to focus on creating a re-usable Module in Terraform. 

>**So what is a module in Terraform anyways?** 
>
>Really, Terraform sees any parent folder with terraform configuration files as a module. When Terraform runs, it collects all the ".tf" configuration files in a folder (or rather, a module) together and runs them as a single master configuration in the appropriate order.

>**What goes into a module?**
>
>Generally a module will consist of three files. The "main.tf" file where all primary configurations exist. The "variables.tf" file where variables for that module are declared. And the "output.tf" file where any outputs are declared. You've already seen what goes into a main.tf file so let's talk about the other two.

The "variables.tf" file or "vars.tf" file as it is sometimes called, is made up of all pre-defined variables for a file. Here is an example of how to construct a variable:

```
variable "location" {
    description = "Location where Resources will be deployed"
    default = "East US"
}
```

The example above declares a "location" variable, which can include a description and a default value, though these are not required. If no default value is supplied, the module will expect these to be supplied by some other means, either through direct user input or by outputs.

Speaking of outputs, let's look at an example of what would go into the "output.tf" file:

```
output "app_service_fqdn" {
    value = "${azurerm_app_service.app1_app_service.default_site_hostname}"
}
```

The example above declares an "app_service_fqdn" output and specifies the value comes from the result of the app service default site hostname. This means we can use computed values from our deployment elsewhere. Like for example, in another module.

The ability for setting up inputs and outputs using declarative language gives us the flexibility needed to generalize configurations so they can be "stamped" on demand. But how does it work? Let's build a module to find out.

### Folder Structure

The first thing we need to do here is create a new folder in our C:\Terraform folder. We are going to call this folder "_modules". Next, create a sub-folder in "_modules" called "standard_application". Now let's move the main.tf file we created in the previous section into this folder. In Visual Studio Code, drag the file from it's current parent location to the "standard_application" sub-folder you just created.

Next, create two more files in the "standard_application" folder. Create an empty "variables.tf" file and an empty "output.tf" file. We'll populate these later as we get a better feel for what variables we need.

This creates the baseline of our module, but we aren't done. We are going to create two more folders at the root of C:\Terraform. First create a folder called "dev", then a folder called "prod". We'll work with these folders more toward the end of this section.

### Generalizing the Module

Technically the "main.tf" file we created earlier is part of a module now called "standard_application" but we cannot re-use this module yet. There are certain parameters we have hard-coded which will prevent us from dynamically calling the module. Let's change that by replacing those hard-coded values with variables.

Open up the "variables.tf" file and paste the following code:

```
variable "location" {
    description = "Location where Resources will be deployed"
}

variable "application_plan_tier" {
    description = "Tier of the Application Plan (Free, Shared, Basic, Standard, Premium, Isolated)"
}

variable "application_plan_size" {
    description = "Instance Size of the Application Plan (F1, D1, B1, B2, B3, S1, S2, S3, P1v2, P2v2, P3v2, PC2, PC3, PC4, I1, I2, I3)"
}

variable "application_name" {
    description = "Name of the Application"
}

variable "sql_administrator_login" {
    description = "Login for the Managed SQL Instance"
}

variable "sql_administrator_password" {
    description = "Password for the Managed SQL Instance"
}

variable "environment" {
    description = "Environment of all deployed resources"
}
```
>**A word on variables**
>
>These seven variables will give us what we need to generalize the module. There could be more variables if we desired, or less if we still wanted to hard code certain elements (like the plan tier and size) to the module. This comes down to what you are trying to achieve with the module. For instance, if you want all your standard apps to share the same plan tier you can exclude it from the variables file and just declare the desired value directly in the "main.tf" file.

With our freshly declared variables, let's open up the "main.tf" file and begin generalizing the resources we previously created.

Replace the existing Resource Group block with the following code:

```
#Resource Group
resource "azurerm_resource_group" "application_rg" {
    name     = "tf-az-${var.application_name}-${var.environment}-rg"
    location = "${var.location}"
}
```

Variables are called by supplying ${var.<variable name>}. Notice we used multiple variables to create a naming convention that will always be used when deploying this type of resource. 

Next, let's generalize the App Service Plan and App Service:

```
#Application Service Plan
resource "azurerm_app_service_plan" "standard_app_plan" {
    name = "tf-az-standard-${var.environment}-plan"
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
```

The above code uses a combination of computed values and variables to generalize these resources so they can be called multiple times from different folders.

>**Wait what?**
>
>Modules have the ability to call other modules. This is why we created the "dev" and "prod" folder earlier. We are going to call the "standard_application" module to generate both a dev environment and a prod environment. Each time, we know the same infrastructure will be deployed, using the standards that we have set in the module (for naming convention, etc.).

Let's finish generalizing our "main.tf" file. Copy and paste this code to replace the previous code:

```
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

resource "azurerm_sql_firewall_rule" "test" {
  name                = "tf-az-${var.application_name}-${var.environment}-allow-azure-sqlfw"
  resource_group_name = "${azurerm_resource_group.application_rg.name}"
  server_name         = "${azurerm_sql_server.standard_sql_server.name}"
  start_ip_address    = "0.0.0.0" # tells Azure to allow Azure services
  end_ip_address      = "0.0.0.0" # tells Azure to allow Azure serivces
}
```

Notice we left the start_ip_address and end_ip_address as hard-coded values. We want to keep these inputs static so we did not generalize them. This will also not affect the dynamic creation of said rule, as it should be the same every time it gets created by Terraform.







refactor what we just deployed into a module-like process
terraform destroy
redeploy to dev
deploy to prod