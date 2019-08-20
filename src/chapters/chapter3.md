## Developing Reusable Code

In this chapter you'll learn:
- What a Terraform module is
- How to generalize Terraform code to make it reusable
- Use variables to pass data into modules

### Terraform Modules

In the last chapter, you wrote your first Terraform code, and learned three Terraform commands: init, plan, and apply. As your Terraform code becomes more complex, and you do more deployments, you may find the need to reuse Terraform code. You can do this with modules.

> **So what is a module in Terraform anyways?** 
>
> In the simplest terms, a module is a collection of declarative Terraform files, grouped together in a folder. That's right - Terraform sees any folder with Terraform files as a module. If you're familiar with other programming lanaguages, you can think of a module like an API - you pass data (variables) into it, infrastructure is provisioned, and data (output) is returned. 

You'll recall from the last chapter, that Terraform collects all ".tf" files in a folder (or rather, a module) when it runs. The files are combined into a single master code declaration, dependencies discovered, and infrastructure is provisioned in the order determined.

#### Structuring modules

Modules consist of three files, generally:
1. A `main.tf` file where all primary code exists. 
2. A `variables.tf` or `vars.tf` file where variables for that module are declared. 
3. An `output.tf` file where any module outputs are declared. 

You've already seen what goes into a main.tf file so let's talk about the other two.

The variables file, is made up of all pre-defined variables (or module inputs) for a file. Here is an example of how to construct a variable:

```
variable "location" {
    description = "Location where Resources will be deployed"
    default = "East US"
}
```

The example above declares a *location* variable, which can include a description and a default value, though these are not required. If no default value is supplied, the module will expect these to be supplied by some other means, either through direct user input or by outputs.

Speaking of outputs, let's look at an example of what might go into an `output.tf` file:

```
output "app_service_fqdn" {
    value = "${azurerm_app_service.app1_app_service.default_site_hostname}"
}
```

The example above declares an "app_service_fqdn" output and specifies the value comes from the result of the app service default site hostname. This means we can use computed values from our deployment elsewhere. Like for example, in another module.

The ability for setting up inputs and outputs using declarative language gives us the flexibility needed to generalize configurations so they can be *stamped-out* on demand. 

### Creating a Generalized Module

Now that you know what goes into a module, let's build one together.

<h4 class="exercise-start">
    <b>Exercise</b>: Generalizing modules
</h4>

The first thing we need to do here is create a new folder in your `C:\terraform` folder. We are going to call this folder `_modules`. 

Next, create a sub-folder in `_modules` called `standard_application`. 

Now move the `main.tf` file we created in the previous chapter into this folder. In VS Code, drag the file from it's current parent location to the `standard_application` sub-folder you just created.

Next, create two more files in the `standard_application` folder. Create an empty `variables.tf` file and an empty `output.tf` file. We'll populate these later as we get a better feel for what variables we need.

This creates the baseline of our module, but we aren't done. 

We are going to create two more folders at the root of `C:\terraform`. First create a folder called `dev`, then a folder called `prod`. We'll work with these folders more toward the end of this section.

#### Generalizing the Module

Technically the `main.tf` file we created earlier is part of a module now called *standard_application* but we cannot re-use it yet. There are certain parameters we have hard-coded which will prevent us from dynamically calling the module. Let's change that by replacing those hard-coded values with variables.

> **Before we go further**
>
> Please remove the provider block at the top of the `main.tf` file we created earlier. Save the provider code -- we'll need it later. We'll talk about why you have to do this later. 

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

variable "environment" {
    description = "Environment of all deployed resources"
}
```

> **A word on variables**
>
> These seven variables will give us what we need to generalize the module. There could be more variables if we desired, or less if we still wanted to hard code certain elements (like the plan tier and size) to the module. This comes down to what you are trying to achieve with the module. For instance, if you want all your standard apps to share the same plan tier you can exclude it from the variables file and just declare the desired value directly in the "main.tf" file.
>
> We like to think of modules like an API. The variables represent input values that allow the module to be flexible and provision different infrastructure configurations - they form the API's surface and interface. The module's `main.tf` code then represents the implementation of the API. 

With our freshly declared variables, let's open up the *standard_application* `main.tf` file and begin generalizing the resources we previously created.

Replace the existing Resource Group block with the following code:

```
# Resource Group
resource "azurerm_resource_group" "application_rg" {
    name     = "tf-az-${var.application_name}-${var.environment}-rg"
    location = "${var.location}"
}
```

Variables are called by supplying ${var.<variable name>}. You'll also notice that you can place variables side-by-side in Terraform code (like we did with the *name* key/value pair above.

Next, let's generalize the App Service Plan and App Service:

```
# App Service Plan
resource "azurerm_app_service_plan" "standard_app_plan" {
    name                = "tf-az-standard-${var.environment}-plan"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.application_rg.name}"
    sku {
        tier = "${var.application_plan_tier}"
        size = "${var.application_plan_size}"
    }
}

# App Service
resource "azurerm_app_service" "app1_app_service" {
    name                = "tf-az-${var.application_name}-${var.environment}-app"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.application_rg.name}"
    app_service_plan_id = "${azurerm_app_service_plan.app_plan.id}"
}
```

This concludes the exercise.

<div class="exercise-end"></div>


### Calling Modules

In the last section, you learned how to take existing Terraform code and turn it into a generalized module. Now that we have this module, let's use it!

<h4 class="exercise-start">
    <b>Exercise</b>: Calling a module
</h4>

In the last section, you created a `dev` and `prod` folder within `C:\terraform`. In this exercise, you'll be creating Terraform code in each folder and referencing the *standard_application* module.

Let's get started. 

In the "dev" folder, create a new `main.tf` file. 

> **Don't forget the provider!**
>
> Remember when we got rid of the provider declaration in the `standard_application\main.tf` file earlier in this chapter? We are going to declare the provider in this file `dev\main.tf`. If a provider is not declared in a module, the module will use the provider of the configuration file that called the module. 
>
> It is generally best to keep provider declarations at the root folder where modules will be called. Only declare a provider in a module when you need to override the default provider used (like when you need to use a specific provider version for compatibility).

Open the `dev\main.tf` file you just created and paste the following code (or the provider code you saved earlier):

```
provider "azurerm" {
    tenant_id       = ""
    subscription_id = ""
    use_msi = true
}
```

Just like before, make sure to place your Azure Tenant and Subscription ID inside the quotes next to the appropriate parameter.

Next we are going to call the previously created "standard_application" module and supply the required values. 

> **Module inception?**
>
> If you recall, modules are simply a folder with Terraform code within. So technically, the new `main.tf` file you created *is* a module...and we'll be adding code to call the *standard_application* module. In other words, modules can call other modules. 
>
> We're going to call the "standard_application" module to generate both a dev environment and a prod environment (hence the `dev` and `prod` folders). In large deployments, this saves us time. It also reduces the chance of errors because we know the same infrastructure will be deployed -- using the standards that we have set in the module (for naming convention, etc.).

Paste the following code below the provider block:

```
module "standard_application" {
    source                     = "../_modules/standard_application/"

    environment                = "dev"
    application_name           = "app1"
    location                   = "East US"
    application_plan_tier      = "Basic"
    application_plan           = "B1"
}
```

To call a module, declare it with a module {} block. The name of the module can be anything you want. In our case the name is "standard_application". The source parameter specifies where the module is located in the file system, relative to the current file. The rest of the parameters are the variables we created earlier. Remember, any variable without a default value must be supplied by the user when calling the module directly.

It's good to know that modules don't have to be located on your local file system - they can be located in an external location. Tht's a more advanced topic, and we're not going to cover it in today's workshop. Feel free to investigate further if you're interested.

#### Testing your changes

Before we go any further, we need to destroy the resources we created earlier. We could use a built-in command from Terraform, `terraform destroy` (which destroys anything created by Terraform), or we can manually delete the resources from the Azure Portal by deleting the resource group we deployed previously.

It's probably easiest to navigate to the Azure portal and delete the resource group. Do that now. Come back here once you're finished. 

Now that your Azure environment is cleaned up, let's deploy the resources like we did before.

First make sure we are in the c:\terraform\dev folder in our terminal. If not, cd to the appropriate folder level:

```bash
cd c:\terraform
```

Run `terraform init` to initialize our configuration - you have to do this again because the new root `main.tf` file is located in a new sub-folder, `dev`.

```bash
terraform init
```

Next, run the `terraform plan` command. This isn't a required step for deployment but it is a good practice to follow in order to reduce potential errors.

```bash
terraform plan
```

If the output of the plan checks out, let's apply:

```bash
terraform apply
```

The resources will deploy to your Azure subscription exactly as written. 

#### Checking your deployment

Open the Azure Portal and look for the resource group you created. This should look similar to what we deployed manually. Only now, we can deploy this as many times as we want with different values and it will return unique "standard_application" infrastructure deployments, each with their own unique resource group.

#### Extra credit

Just kidding. There's no extra credit, but if you want, copy the `dev\main.tf` file into the `prod` folder, change a couple of the parameter values we supplied, and deploy terraform from the prod folder to see a "production" environment next to your "development" environment. Note: This is not required for the other modules.

This concludes the exercise.

<div class="exercise-end"></div>

Well done! Another chapter down and you've learned how to make re-usable modules in Terraform. 


