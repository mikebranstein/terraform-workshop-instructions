## Adding a SQL Server and Deploying your App

In this chapter, you'll learn how to:
- provision a SQL server using Terraform
- deploy a web application to the IaC environments

### Provisioning a SQL Server



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


