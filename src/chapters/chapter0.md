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

Our speakers include:

* [Eric Rhoads](https://www.linkedin.com/in/eric-rhoads)
    * Azure Cloud Solution Architect (CSA), [KiZAN Technologies](http://kizan.com)

* [Mike Branstein](https://twitter.com/mikebranstein)
    * Azure Cloud Solution Architect (CSA), [KiZAN Technologies](http://kizan.com)
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

We *highly* recommend creating a FREE Trial Azure subscription using a personal (non-work) Microsoft account. Why? We find Azure subscriptions associated with your corporate credentials (or an existing subscription from work) are often lcoked down, preventing you from logging in correct, creating virtual machines, managing secruity access, updating networking configuration, etc.   

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


### Preparing your Azure environment

You might be wondering how you can participate in a cloud workshop and not need any software installed.

Thanks to the magic of scripting and the Azure Cloud Shell, you'll provision a virtual machine (VM) pre-installed with all the tools you'll need. After it's ready (~5 minutes) we'll login to the VM and you can do all your work from there. 

It takes about 5 minutes to get the VM deployed to your subscription, so let's get started!

<h4 class="exercise-start">
    <b>Exercise</b>: Provisioning a a workshop VM in your Azure Subscription
</h4>

Navigate to the [Azure portal](https://portal.azure.come), then click the *Cloud Shell* link at the top:

<img src="images/chapter0/cloud-shell.png" class="img-override" />

If you've never opened a Cloud Shell, you may encounter a message like this:

<img src="images/chapter0/cloud-shell-2.png" class="img-override" />

If you see that message, select your Azure subscription and click *Create Storage*. Wait until you see a Cloud Shell (Bash) appear:

<img src="images/chapter0/cloud-shell-3.png" class="img-override" />

Using the Bash Cloud Shell, run this command to create your workshop VM:

Create a resource group named workshop-vm-rg:

```bash
[ -d "azure-build-scripts-master" ] && rm -rf azure-build-scripts-master; curl -LOk https://github.com/mikebranstein/azure-build-scripts/archive/master.zip; unzip master.zip; cd azure-build-scripts-master/terraform-workshop; chmod +x build.sh; ./build.sh
```

Watch this quick video on how to do this:

<img src="images/chapter0/create-vm.gif" class="img-override" />

When it's finished, your VM will be ready! You'll find the VM in a resource group named `tf-as-workshop-rg`. The VM will be named `tf-az-workshop-vm`. The username and password for the VM are:
- username: workshopadmin
- password: P.$$w0rd1234

If you'd liek to change the password, navigate to the VM in the Azure portal and find the *Change Password* blade on the left.

<div class="exercise-end"></div>

That's it for the pre-requisites for today's workshop. Wait until your VM is created, and we'll be getting started soon!

