## Adding a SQL Server and Deploying your App

In this chapter, you'll learn how to:
- provision a SQL server using Terraform
- deploy a web application to the IaC environments

### Provisioning a SQL Server

Every great app needs a database, am i right? Myabe not, but we'll be provisioning an Azure SQL database regardless ;-)

> **What is Azure SQL Database?**
>
> Azure SQL Database is a general-purpose relational database-as-a-service (DBaaS) based on the latest stable version of Microsoft SQL Server Database Engine. SQL Database is a high-performance, reliable, and secure cloud database that you can use to build data-driven applications and websites in the programming language of your choice, without needing to manage infrastructure.

We'll be using Azure SQL Databases because they're easy to create, inexpensive, and the foundation of many apps in Azure. 

Let's get to it.

<h4 class="exercise-start">
    <b>Exercise</b>: Adding an Azure SQL Database to Terraform
</h4>

Start by opening the *standard_application* module's main.tf file. Add the following to the bottom:

```
resource "azurerm_sql_server" "standard_sql_server" {
  name                         = "tf-az-standard-sql-${var.environment}-${random_integer.ri.result}"
  resource_group_name          = "${azurerm_resource_group.application_rg.name}"
  location                     = "${var.location}"
  version                      = "12.0"
  administrator_login          = "${var.sql_administrator_login}"
  administrator_login_password = "${var.sql_administrator_password}"
}

resource "azurerm_sql_database" "app1_db" {
  name                = "tf-az-${var.application_name}-${var.environment}-db"
  resource_group_name = "${azurerm_resource_group.application_rg.name}"
  location            = "${var.location}"
  server_name         = "${azurerm_sql_server.standard_sql_server.name}"
}

resource "azurerm_sql_firewall_rule" "test" {
  name                = "tf-az-${var.application_name}-${var.environment}-allow-azure-sqlfw${random_integer.ri.result}"
  resource_group_name = "${azurerm_resource_group.application_rg.name}"
  server_name         = "${azurerm_sql_server.standard_sql_server.name}"
  start_ip_address    = "0.0.0.0" # tells Azure to allow Azure services
  end_ip_address      = "0.0.0.0" # tells Azure to allow Azure serivces
}
```

The first declaration creates an Azure SQL Server named `tf-az-standard-sql-{env}-{random-integer}` (you'll notice we re-used the same rnadom integer value to ensure the SQL Server name was unique). The second adds a database named `tf-az-${var.application_name}--${var.environment}-db` to the SQL Server. The third enables other Azure services to communicate with the SQL Server. 

Notice we left the start_ip_address and end_ip_address as hard-coded values. We want to keep these inputs static so we did not generalize them. This will also not affect the dynamic creation of said rule, as it should be the same every time it gets created by Terraform.

#### Update the module variables

You may have noticed we're using several new variables. Let's add them to the end of the `variables.tf` file:

```
variable "sql_administrator_login" {
    description = "Login for the Azure SQL Instance"
}

variable "sql_administrator_password" {
    description = "Password for the Azure SQL Instance"
}
```

#### Supply the module with variable values

After adding the variables, update the supplied values of the variables in your main.tf files (dev and prod) with the supplied values.

For dev:

```
module "standard_application" {
    source                     = "../_modules/standard_application/"

    environment                = "dev"
    application_name           = "app1"
    location                   = "East US"
    application_plan_tier      = "Basic"
    application_plan_size      = "B1"
    sql_administrator_login    = "sqladmin"
    sql_administrator_password = "SQLP@ss123"
}
```

...and prod:

```
module "standard_application" {
    source                     = "../_modules/standard_application/"

    environment                = "prod"
    application_name           = "app1"
    location                   = "East US"
    application_plan_tier      = "Basic"
    application_plan_size      = "B1"
    sql_administrator_login    = "sqladmin"
    sql_administrator_password = "SQLP@ss123"
}
```

#### Testing your changes

Navigate to the dev folder, initialize Terraform:

```bash
terraform init
```

Run a plan to check out what's going to happen:

```bash
terraform plan
```

And apply the changes:

```bash
terraform apply
```

Go out to the Azure portal and check to see the resources have been created. 

#### Getting the connection string to your database

Navigate to your dev SQL Database, and click on the *Connection strings* blade:

<img src="images/chapter5/connection-strings.png" class="img-small" />

Copy the ADO.NET connection string and save it - you'll need this in the next step.

This concludes the exercise.

<div class="exercise-end"></div>


### Verify the web app works

Before we deploy the web app, let's make sure it works. 

You'll recall that we downloaded a .zip file to your Terraform VM in an earlier chapter. Locate the zip file, unzip it, open the directory, and let's go.

<h4 class="exercise-start">
    <b>Exercise</b>: Compiling the solution
</h4>

Start by opening the solution in **Visual Studio 2019** by double-clicking the `ContosoUniversity.sln` file in the *src* folder of the extracted files:

<img src="images/chapter1/solution-file.png" />

> **Logging into Visual Studio the first time**
>
> When you open Visual Studio the first time, it may take a few minutes. Be patient. You'll probably be prompted to sign in. Use your Microsoft account to sign in (the same one you used to sign up for the Azure trial).

The opened solution should look like this:

<img src="images/chapter1/opened-solution.png" />

Build and debug the solution. You should see the site load in your browser.

<img src="images/chapter1/site.png" />

This concludes the exercise.

<div class="exercise-end"></div>

That's it! You're up and running and ready to move on! In the next section, you'll learn how to deploy your website to Azure.


### Understanding App Service and Web Apps

In the last part of this chapter, you'll learn how to deploy a web app to an Azure Web App provisioned by Terraform. In short, I like to think of Azure Web Apps like IIS in the cloud, but without the pomp and circumstance of setting up and configuring IIS.

Web Apps are also part of a larger Azure service called the App Service, which is focused on helping you to build highly-scalable cloud apps focused on the web (via Web Apps), mobile (via Mobile Apps), APIs (via API Apps), and automated business processes (via Logic Apps). 

We don't have time to fully explore all of the components of the Azure App Service, so if you're interested, you can read more [online](https://azure.microsoft.com/en-us/services/app-service/).

#### What is an Azure Web App?

As we've mentioned, Web Apps are like IIS in the cloud, but calling it that seems a bit unfair because there's quite a bit more to  Web Apps:

* **Websites and Web Apps:** Web Apps let developers rapidly build, deploy, and manage powerful websites and web apps. Build standards-based web apps and APIs using .NET, Node.js, PHP, Python, and Java. Deliver both web and mobile apps for employees or customers using a single back end. Securely deliver APIs that enable additional apps and devices.

* **Familiar and fast:** Use your existing skills to code in your favorite language and IDE to build APIs and apps faster than ever. Access a rich gallery of pre-built APIs that make connecting to cloud services like Office 365 and Salesforce.com easy. Use templates to automate common workflows and accelerate your development. Experience unparalleled developer productivity with continuous integration using Visual Studio Team Services, GitHub, and live-site debugging.

* **Enterprise grade:** App Service is designed for building and hosting secure mission-critical applications. Build Azure Active Directory-integrated business apps that connect securely to on-premises resources, and then host them on a secure cloud platform that's compliant with ISO information security standard, SOC2 accounting standards, and PCI security standards. Automatically back up and restore your apps, all while enjoying enterprise-level SLAs.

* **Build on Linux or bring your own Linux container image:** Azure App Service provides default containers for versions of Node.js and PHP that make it easy to quickly get up and running on the service. With our new container support, developers can create a customized container based on the defaults. For example, developers could create a container with specific builds of Node.js and PHP that differ from the default versions provided by the service. This enables developers to use new or experimental framework versions that are not available in the default containers.

* **Global scale:** App Service provides availability and automatic scale on a global datacenter infrastructure. Easily scale applications up or down on demand, and get high availability within and across different geographical regions. Replicating data and hosting services in multiple locations is quick and easy, making expansion into new regions and geographies as simple as a mouse click.

* **Optimized for DevOps:** Focus on rapidly improving your apps without ever worrying about infrastructure. Deploy app updates with built-in staging, roll-back, testing-in-production, and performance testing capabilities. Achieve high availability with geo-distributed deployments. Monitor all aspects of your apps in real-time and historically with detailed operational logs. Never worry about maintaining or patching your infrastructure again.

### Deploying to a Web App from Visual Studio

Now that you understand the basics of web apps, let's create one and deploy our app to the cloud! 

<h4 class="exercise-start">
    <b>Exercise</b>: Deploying to a Web App from Visual Studio 2019
</h4>

In this exercise, let's start by deploying to the dev site. We won't actually deploy to the prod site, but that should be easy enough to do on your own once you've done it in dev.

Before we deploy the web app, let's take a moment to update the database connection string with the proper settings.

Open the appsettings.json file and replace the *DefaultConnection* database connection string with the connection string to your SQL database. Remember, you saved this connection string earlier in the chapter.

> **WARNING**
>
> You cannot just copy/paste the connection string. Inside the connection string is a username and password field that needs completed. The username and password is inside of your Terraform code - find it in `main.tf` and replace the values!

<img src="images/chapter5/appsettings.png" class="img-small" />

With the connection string updated, let's start the deployment process.

From Visual Studio, right-click the *ContosoUniversity* project and select *Publish*. In the web publish window, select *Microsoft Azure App Service*, *Select Existing*, and press *Publish*. 

On the next page, select your Azure subscription, and select the Resource Group you created with Terraform earlier (mine was named *workshop-rg*), then select the dev web app created by your Terraform code. 

Press *OK*.

After the web app is deployed, it will open the site. You should see the Contoso University site displayed.

This concludes the exercise. 

<div class="exercise-end"></div>

> **Don't forget about Prod!**
>
> Just in case you forgot, make sure you deploy the web app to prod before continuing.

Bravo! You've deployed a web app t the infrastructure you created via Terraform. This concludes the chapter, but the story isn't finished. In the next chapter, you'll learn how to secure your web apps by using an Azure App Gateway and Web Application Firewall (provisioned with Terraform, of course).


