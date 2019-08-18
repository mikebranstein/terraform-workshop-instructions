## Introduction

Welcome to our Terraform Workshop! 

We've been using Terraform to deploy Azure infrastructure for the past year, and have enjoyed the experience so much, we felt we needed to bring it to you. 

### What is Terraform?

[Terraform](https://www.terraform.io/) is an open source tool Hashicorp that allows you to safely and predictably create, change, and improve infrastructure. It codifies APIs into declarative configuration files that can be shared amongst team members, treated as code, edited, reviewed, and versioned.

With Terraform you can:
1. Write infrastructure as code
2. Plan changes to your infrastructure
3. Create reproducible infrastrcuture

#### Write infrastructure as code

With Terraform, you define infrastructure as code to increase productivity and transparency. Your Terraform can be (and should be) stored in a version control system, shared, and collaborated on by a team. With this approach, you track the incremental changes and historical state of your infrastructure. And, by nature, the codification of the infrastructure is automation friendly, so it can sit inside of a CICD pipeline to dynamically deploy infrastructure, then the code that runs on the infrastructure.

#### Plan changes to your infrastructure

Terraform provides an elegant user experience for teams to safely and predictably make changes to infrastructure. 

Teams can understand how a minor change could have potential cascading effects across an infrastructure before executing that change (through a Terraform process called a plan). Terraform builds a dependency graph from the configurations, and walks this graph to generate plans, refresh state, and more.

Terraform also separates the *plan* process discussed above from the *apply* process, which makes the changes to the infrastructure. Separating plans and applies reduces mistakes and uncertainty at scale. Plans show teams what would happen, applies execute changes.

Terraform also have a rich library of infrastructure *providers* (Azure, AWS, GCP, OpenStack, VMware, Hyper-V, and more), which allow you to make changes across multiple on-premises and cloud environments at the same time. 

#### Create reproducible infrastrcuture

Terraform lets teams easily use the same configurations in multiple places to reduce mistakes and save time. You can use the same configuration files to deploy multiple identical environments. Common Terraform configurations (like SQL/IIS or LEAN/MEAN stack apps) can be packaged as modules and used across teams and organizations.

### About the Workshop


#TODO: remove next section when finished

Add more verbiage here.

- VM image (Mike) - DONE
    - Windows 10
    - Visual Studio 2019
    - .NET Core 2.2
    - VS Code
    - Terraform (in path)
    - Chrome pre-installed
- Update the ARM Template to use stored VM image - DONE
- Update ARM Template to include
    - Storage Account
- Deployed VM & Storage Account from ARM Template

- TF (Eric)
    - Modular TF using Storage account as backend
    - Module for App Service and SQL
    - Module for Shared Services - WAF/App Gateway
    - parameterization in modules
        - RG
        - Environment
    - High-level Main.tf for dev and prod

Web App (Mike)
    - Fabrikam
    - .NET Solution


Potential agenda:
- Brief Intro/Presentation/About Terraform - MIKE

DONE - Chapter 0: Create an Azure Subscription if you need one - MIKE

- Chapter 1: Getting started quick - MIKE
    - Setup VM
    - Subscription ID & Tenant ID
    - Create RG view in portal

- Chapter 2: - ERIC
    - Use new TF code to add:
        - RG
        - App Service Plan
        - App Service
    - A side callout/discussion on naming standards
        - lowercase, dashes, etc.
    - Deploy this (w/o modules to Azure)
    - Test that website works (default IIS page)

- Chatper 3: Modules - ERIC
    - Refactor what we just deployed into a module-like process
    - Blow away existing RG
    - Re-deploy to dev
    - Deploy to production

DONE - Chapter 4: State management and adding a new module - MIKE
    - Discuss State Management, why it's important
    - Setup TF Backend and explain chicken/egg scenario
    - Deploy, test, view statefile

- Chapter 5: Add SQL and Deploy App - MIKE
    - Add in SQL Database
    - Use VS to deploy the app to App Service
    - deploy to dev/prod
    - test

- Chapter 6: Securing the web app with a WAF/App Gateway - ERIC
    - Intro to WAF/App Gateway
    - Add WAF module (lot's of stuff)
    - Deploy to dev & prod
    - Test

- Closing remarks

Our speakers include:

* [Eric Rhoads](https://www.linkedin.com/in/eric-rhoads)
    * Cloud Solution Architect (CSA), [KiZAN Technologies](http://kizan.com)

* [Mike Branstein](https://twitter.com/mikebranstein)
    * Cloud Solution Architect (CSA), [KiZAN Technologies](http://kizan.com)
    * [Brosteins](https://brosteins.com)
    * [LinkedIn](https://www.linkedin.com/in/mikebranstein/)

### Getting Started

To get started you'll need the following pre-requisites. Please take a few moments to ensure everything is installed and configured.

* Microsoft Windows PC or Mac or Linux. Just have a laptop.
* [Azure Subscription](https://azure.microsoft.com) (Trial is ok, or an Azure account linked to a Visual Studio subscription. See later sections of this chapter to create a free trial account or activate your Visual Studio subscription)

### What You're Building

Using Terraform to deploy Azure infrastructure is easy, but there's a lot of different resources you could deploy - Azure is big. Really big. Too big to talk about all things Azure in a single day. 

We've assembled an exciting workshop to introduce you to several Azure services that infra and dev teams typically deploy:
* [App Service Plan](https://docs.microsoft.com/en-us/azure/app-service/overview-hosting-plans)
* [Web app](https://azure.microsoft.com/en-us/services/app-service/web/)
* [Azure SQL Database](https://azure.microsoft.com/en-us/services/sql-database/)
* [Virtual Machines](https://azure.microsoft.com/en-us/services/virtual-machines/)
* [App Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/overview)

In this workshop, you'll learn be learning how to get started with Terraform and provision Azure resources. 

In chapter 2, you'll start by writing code to deploy Azure resource groups, an App Service Plan, and an App Service. 

Then in chapter 3, you'll learn how to create reusage code modules to create identical dev and prod environments. 

Chapter 4 introduces you to Terraform state files, which is how Terraform manages the state of your infrastructure.

In chapter 5, you'll add a SQL database to your infrastructure and deploy a web site.

The workshop wraps up in chapter 6 by deploying an Azure App Gateway and Web Applicaiton Firewall (WAF) to protect the website you deployed previously.

### Key concepts and takeaways

* Navigating the Azure portal
* Using Azure Resource Groups to manage multiple Azure services
* Deploying a web app to Azure web app service using Terraform
* Terraform naming conventions and standards 
* Why Terraform state files are important and methods for managing state
* Deploying Azure SQL databases and apps from Visual Studio
* How Azure App Gateways and WAFs work, and how to deploy with Terraform

### Materials

You can find additional lab materials and presentation content at the locations below:

* Presentation: [https://github.com/mikebranstein/terraform-workshop](https://github.com/mikebranstein/terraform-workshop)
* Source code for the code used in this guide: [https://github.com/mikebranstein/terraform-workshop](https://github.com/mikebranstein/terraform-workshop)
* This guide: [https://github.com/mikebranstein/terraform-workshop-instructions](https://github.com/mikebranstein/terraform-workshop-instructions)


### Creating a Trial Azure Subscription

> **If you already have an Azure account** 
>
> If you have an Azure account already, you can skip this section. If you have a Visual Studio subscription (formerly known as an MSDN account), you get free Azure dollars every month. Check out the next section for activating these benefits.

There are several ways to get an Azure subscription, such as the free trial subscription, the pay-as-you-go subscription, which has no minimums or commitments and you can cancel any time; Enterprise agreement subscriptions, or you can buy one from a Microsoft retailer. In exercise, you'll create a free trial subscription.

<h4 class="exercise-start">
    <b>Exercise</b>: Create a Free Trial Subscription
</h4>

Browse to the following page [http://azure.microsoft.com/en-us/pricing/free-trial/](http://azure.microsoft.com/en-us/pricing/free-trial/) to obtain a free trial account.

Click *Start free*.

Enter the credentials for the Microsoft account that you want to use. You will be redirected to the Sign up page.

> **Note** 
>
> Some of the following sections could be omitted in the Sign up process, if you recently verified your Microsoft account.

If you already ahve an Azure subscription tied to your Microsoft account, you may see a screen like this:

<img src="images/chapter0/existing-subscription.png" class="img-medium" />

You're wekcome you use your existing subscription for the bootcamp. If you're planningto use your existing subscription, you can skip this exercise. Click *Sign Up* to create a new subscription.

Complete step 1 by entering your mobile phone number.

<img src="images/chapter0/verify.png" class="img-medium" />

Select *Text me* or *Call me* to verify that you are a real person. Typein the verification code you receive on the phone or via text.

Next, complete the Payment information section.

> **A Note about your Credit Card** 
>
> Your credit card will not be billed, unless you remove the spending limits. If you run out of credit, your services will be shut down unless you choose to be billed.

<img src="images/chapter0/payment.png" class="img-medium" />

Press *Next* after completing the credit card section.

In the *Technical Support* section, select the last option (No technical support) and click *Next*.

<img src="images/chapter0/tech-support.png" class="img-medium" />

In the *Agreement* section, check the *I agree to the subscription Agreement*, *offer details*, and *privacy statement* option, and click *Sign up*.

Your free subscription will be set up, and after a while, you can start using it. Notice that you will be informed when the subscription expires.

<img src="images/chapter0/agreement.png" class="img-medium" />

Your free trial will expire in 29 days from it's creation.

<div class="exercise-end"></div>

### Activating Visual Studio Subscription Benefits

If you happen to be a Visual Studio subscriber (formerly known as MSDN) you can activate your Azure Visual Studio subscription benefits. It is no charge, you can use your MSDN software in the cloud, and most importantly you get up to $150 in Azure credits every month. You can also get 33% discount in Virtual Machines and much more.

<h4 class="exercise-start">
    <b>Exercise</b>: Activate Visual Studio Subscription Benefits
</h4>

To active the Visual Studio subscription benefits, browse to the following URL: [http://azure.microsoft.com/en-us/pricing/member-offers/msdn-benefits-details/](http://azure.microsoft.com/en-us/pricing/member-offers/msdn-benefits-details/)

Scroll down to see the full list of benefits you will get for being a MSDN member. There is even a FAQ section you can read.

Click *Activate your monthly Azure credit* to activate the benefits.

<img src="images/chapter0/activate.png" class="img-medium" />

You will need to enter your Microsoft account credentials to verify the subscription and complete the activation steps.

<div class="exercise-end"></div>

### Preparing your Azure environment

You might be wondering how you can participate in a cloud workshop and not need any software installed.

Thanks to the Azure Resource Manager and some nifty templates I put together, we're going to provision a virtual machine (VM) with Visual Studio (and all the tools you'll need) installed in your Azure subscription. From that point forward, you can work from the VM. 

It takes about 15 minutes to get the VM deployed to your subscription, so let's get started!

<h4 class="exercise-start">
    <b>Exercise</b>: Provisioning a Visual Studio Community VM in your Azure Subscription
</h4>

First, we'll createa storage account and copy a Windows VM image into the storage account.

In the Azure portal, click the *Cloud Shell* link at the top:

<img src="images/chapter0/cloud-shell.png" class="img-override" />

If you've never opened a Cloud Shell, you may encounter a message like this:

<img src="images/chapter0/cloud-shell-2.png" class="img-override" />

If you see that message, select your Azure subscription and click *Create Storage*. Wait until you see a Cloud Shell (Bash) appear:

<img src="images/chapter0/cloud-shell-3.png" class="img-override" />

Using the Bash Cloud Shell, run various Azure CLI commands. 

Create a resource group named workshop-vm-rg:

```bash
az group create --location eastus --name workshop-vm-rg
```

Create a storage account in the resource group. Be sure to replace <storage-account-name> with a random storage account name (It must be unique!). For example, I used *mysameb2019*:

```bash
az storage account create --name <storage-account-name> --resource-group workshop-vm-rg --location eastus
```

Create a container in your storage account to hold VHDs:

```bash
az storage container create --account-name <storage-account-name> --name vhds
```

Start copying the virtual machine image from my storage account to yours.

```bash
az storage blob copy start --account-name <storage-account-name> --destination-blob terraform-win10-vs2019-v2.vhd --destination-container vhds --source-uri https://workshopvhds.blob.core.windows.net/vhds/terraform-win10-vs2019-v2.vhd
```

This will begin the copying process, but the copy may take 5-10 mintues. Use this command to check the status of the copy:

```bash
az storage blob show --account-name <storage-account-name> --name terraform-win10-vs2019-v2.vhd --container-name vhds --query "properties.copy"
```

When you run this command, you'll see various status messages showing you the copy progress. Wait for the completionTime and progress status to show a completion. In the image below, you can see my copy has not yet completed, and the progress is 141942784/136365212160, or ~0.1%.

<img src="images/chapter0/status-2.png" class="img-override" />

Now that the copy has finished, get the URI of your virtual machine disk image. For example, it's https://storage-account-name}.blob.core.windows.net/vhds/terraform-win10-vs2019-v2.vhd. Keep this URI handy.

#### Deploying the Virtual Machine

Start by clicking the *Deploy to Azure* button below.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmikebranstein%2Fvscommunity-workshop-vm%2Fmaster%2Ftemplate.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png" class="img-override" /></a>

This opens the Azure portal in a new tab of your browser. If you're prompted to sign in, do so. 

When the page loads, you'll see this custom deployment page:

<img src="images/chapter0/custom-deployment.png" class="img-override" />

#### Under *Basics*, select/enter the following
- Subscription: *your Azure subscription*
- Resource group: *Create new*
- Resource group name: *workshop-rg*, or some other name that's easy to remember
- Location: *East US*
- Os Blob Uri: *the URI of the virtual machine image you just finished copying*

> **Resource Groups** 
>
> Formally, resource groups provide a way to monitor, control access, provision and manage billing for collections of assets that are required to run an application, or used by a client or company department. Informally, think of resource groups like a file system folder, but instead of holding files and other folders, resource groups hold azure objects like storage accounts, web apps, functions, etc.

> **Naming Resource Groups** 
>
> I like to name my resource groups after their purpose, and append them with *-rg*, which signifies they are a resource group. 


#### Under *Settings*, enter
- Virtual Machine Name: *workshop-vm*, or some other name that is less than 15 characters long, and no special characters
- Admin Username: *your first name*, or some other username without spaces
- Admin Password: *P@ssW0rd1234*, or another 12-character password with upper, lower, numbers, and a special character 
- Os Blob URI: *https://{storage-account-name}.blob.core.windows.net/vhds/terraform-win10-vs2019-v2.vhd*

> **WARNING** 
>
> Do not forget your username and password. Write it down for today. 

#### Approving the "Purchase"

Scroll down to the bottom of the page and click *I agree to the terms and conditions stated above*.

Press the *Purchase* button.

#### Deploying the VM

After a few moments, the deployment of your VM will begin, and you'll see a status notification in the upper right:

<img src="images/chapter0/deployment-start1.png" class="img-override" />

...and a deployment tile on your dashboard:

<img src="images/chapter0/deployment-start2.png" class="img-override" />

Now, wait for about 10 minutes and your virtual machine will be deployed and ready to use.

<div class="exercise-end"></div>

That's it for the pre-requisites for today's workshop. Wait until your VM is created, and we'll be getting started soon!

