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



folder structure (standard application, dev, prod)
files (main, output, variables)
refactor what we just deployed into a module-like process
terraform destroy
redeploy to dev
deploy to prod