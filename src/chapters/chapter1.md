## Getting started in Azure

### Pre-requisites

Before we go any further, be sure you have all the pre-requisites downloaded and installed. You'll need the following:

* Microsoft Windows PC or Mac
* Evergreen web browser (Edge, Chrome, Firefox)
* [Azure Subscription](https://azure.microsoft.com) (trial is ok, and you should have already done this in the chapter 0)
* A Visual Studio Community edition VM running in Azure (see chapter 0 for setting this up)

> **NOTE**
>
> If you've been following along, you should have all of these above items. 

### Organizing your resources in the Azure portal

One of the most important aspects of your Azure subscription and using the Azure portal is organization. You can create a lot of Azure resources very quickly in the portal, and it can become cluttered quickly. So, it's important to start your Azure subscription off right.

Our first stop will be to create a new Dashboard to organize our Azure resources we're building today.

<h4 class="exercise-start">
    <b>Exercise</b>: Create a Dashboard
</h4>

#### Creating a Dashboard

We'll start by creating a dashboard. 

Login to the Azure portal, click *+*, give the dashboard name, and click *Done customizing*.

<img src="images/chapter1/new-dashboard.gif" class="img-medium" />

That was easy! Dashboards are a quick way of organizing your Azure services. We like to create one for the workshop because it helps keep everything organized. You'll have a single place to go to find everything you build today.

#### Pinning a Resource Group to the Dashboard

Now that you have a new dashboard, let's put something on it. We'll be searching for the resource group you created in chapter 0 (the one that is holding your VM), and pinning it to this dashboard.

> **Resource Groups** 
>
> You'll recall from the last chapter that resource groups provide a way to monitor, control access, provision and manage billing for collections of assets that are required to run an application, or used by a client or company department. Informally, think of resource groups like a file system folder, but instead of holding files and other folders, resource groups hold azure objects like storage accounts, web apps, functions, etc.

Start by searching for the resource group you created in chapter 0. My resource group was called *workshop-rg*. 

<img src="images/chapter1/find-resource-group.gif" class="img-override" />

Click in the search bar at the top. If you're lucky your resource group will be at the very top (like mine was). If not, type it's name and click on it.

This opens the resource group. Next, click the *pin* icon at the upper-right to pin the resource group to your dashboard:

<img src="images/chapter1/pin-resource-group.png" class="img-large" />

Finally, close the resource group, by clicking the *X* in the upper right corner (next to the *pin* icon). You should see the resource group pinned to your dashboard:

<img src="images/chapter1/pinned.png" class="img-medium" />

Now that you have the VM's resource group pinned to your dashboard, it will be easy to locate the VM in later exercises.

Go ahead and click ont he Virtual machine, then pin it to the dashboard. When you're finished, you should see something like this:

<img src="images/chapter1/vm-pin.gif" class="img-medium" />


That wraps up the basics of creating dashboard, creating resource groups, and pinning resources to a dashboard. We're not going to take a deep dive into Azure Resource Group. If you're interested in learning more, check out this [article](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-portal).


### Logging into your virtual machine

Next, let's get logged into the VM that we created in chapter 0. 

<h4 class="exercise-start">
    <b>Exercise</b>: Logging into your VM
</h4>

Start by navigating to your Azure portal dashboard. 

Locate the VM resource group you pinned earlier in this chapter and click on your virtual machine:

<img src="images/chapter1/click-vm.png" class="img-override" />

Click the *Connect* button.

<img src="images/chapter1/connect.png"/>

This displays a download window on the right. Press the *Download RDP file* button.

<img src="images/chapter1/connect-download.png" />

This downloads a file to your computer that will open in your Remote Desktop program.

<img src="images/chapter1/connect-download-2.png" />

Click the downloaded file to open a connection to your VM. Enter your username and password you created earlier. 

<img src="images/chapter1/connect-password.png" class="img-override" />

Click *OK* to connect.

If you're prompted by a security message, respond *Yes*:

<img src="images/chapter1/connect-security.png" class="img-override" />

You're now connected to your VM. 

> **Download additional software**
>
> If you're like me, you have a standard toolset you like to use. Please, download software for your VM and don't forget your browser of choice, Notepad++, Visual Studio Code, etc.

This concludes the exercise.

<div class="exercise-end"></div>

Now that you're connected to your VM, you can continue to workshop from inside the VM. 

> **Running a VM in Azure** 
>
> If you're worried about excessive charges to your Azure subscription because you're running a VM constantly, don't worry. This VM is programmed to shut itself down every evening at 7:00 PM EST. 

### Clone project from master branch

Let's get started by getting the `master` branch.

<h4 class="exercise-start">
    <b>Exercise</b>: Getting the bootcamp files
</h4>

Clone or download the `master` branch from [https://github.com/mikebranstein/global-azure-bootcamp-2019](https://github.com/mikebranstein/global-azure-bootcamp-2019).

Use this [link](https://github.com/mikebranstein/global-azure-bootcamp-2019/archive/master.zip) to download a zip file of the `master` branch.

<img src="images/chapter1/downloaded-zip.png" class="img-override" />

> **Unblock the .zip file!** 
>
> Don't open the zip file yet. You may need to unblock it first!

If you're running Windows, right-click the zip file and go to the properties option. Check the *Unblock* option, press *Apply*, press *Ok*.

<img src="images/chapter1/unblock.gif" />

Now it's safe to unzip the file. 

<div class="exercise-end"></div>

### About Contoso University

The Contoso University web app is a small app that is used to manage the faculty, students, courses, and grades of Contoso University. It's not very advanced, but comes with pre-seeded data, and is ideal to demonstrate the concepts of this workshop.  

### Verify the site works

<h4 class="exercise-start">
    <b>Exercise</b>: Compiling the solution
</h4>

Before we can compile the solution, we need ot ensure .NET Core 2.2 is installed on your virtual machine.

Locate and run *Visual Studio Installer* from the Start Menu:

<img src="images/chapter1/vs-installer.png" />

Select the *Modify* option under Visual Studio 2019:

<img src="images/chapter1/modify.png" />

On the right, expand the section labeled *.NET Core cross-platform development*, and check the box labeled *.NET Core 2.2 development tools*.

<img src="images/chapter1/core-22.png" />

Click the *Modify* button on the bottom to install. The install takes approx. 5 minutes to complete.

When the install is finished, you can update Visual Studio 2019 to the latest version (if you want), but it isn't necessary.

Next, open the solution in **Visual Studio 2019** by double-clicking the `ContosoUniversity.sln` file in the *src* folder of the extracted files:

<img src="images/chapter1/solution-file.png" />

> **Logging into Visual Studio the first time**
>
> When you open Visual Studio the first time, it may take a few minutes. Be patient. You'll probably be prompted to sign in. Use your Microsoft account to sign in (the same one you used to sign up for the Azure trial).

The opened solution should look like this:

<img src="images/chapter1/opened-solution.png" />

Build and debug the solution. You should see the Speech Recognition site load in your browser.

<img src="images/chapter1/site.png" />

This concludes the exercise.

<div class="exercise-end"></div>

That's it! You're up and running and ready to move on! In the next section, you'll learn how to deploy your website to Azure.

### Understanding App Service and Web Apps

In the last part of this chapter, you'll learn how to create an Azure Web App and deploy the Speech Service website to the cloud. In short, I like to think of Azure Web Apps like IIS in the cloud, but without the pomp and circumstance of setting up and configuring IIS.

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

Earlier in this chapter, you created a resource group to house resources for this workshop. You did this via the Azure Portal. You can also create Web Apps via the Azure portal in the same manner. But, I'm going to show you another way of creating a Web App: from Visual Studio.

<h4 class="exercise-start">
    <b>Exercise</b>: Deploying to a Web App from Visual Studio 2017
</h4>

> **Visual Studio 2019 Warning** 
>
> This exercise assumes you're running Visual Studio 2019. If you're not, please do.

From Visual Studio, right-click the *ContosoUniversity* project and select *Publish*. In the web publish window, select *Microsoft Azure App Service*, *Create New*, and press *Publish*. This short clip walks you through the process:

<img src="images/chapter1/publish-web-app.gif" class="img-large" />

On the next page, give your Web App a name, select your Azure subscription, and select the Resource Group you created earlier (mine was named *workshop-rg*), and create a new Free App Service Plan. Read below for more details.

> **Unique Web App Names**
>
> Because a web app's name is used as part of it's URL in Azure, you need to ensure it's name is unique. Luckily, Visual Studio will check to ensure your web app name is unique before it attempts to create it. In other words, don't try to use the web app name you see below, because I already used it.

<img src="images/chapter1/web-app-settings.png" class="img-override" />

Click *New...* to create a new Web App plan.

> **Web App Plans** 
>
> Web App plans describe the performance needs of a web app. Plans range from free (where multiple web apps run on shared hardware) to not-so-free, where you have dedicated hardware, lots of processing power, RAM, and SSDs. To learn more about the various plans, check out this [article](https://azure.microsoft.com/en-us/pricing/details/app-service/plans/).

Create a new free plan.

<img src="images/chapter1/new-plan.png" />

After the plan is created, click *Create* to create the Web App in Azure.

When the Azure Web App is created in Azure, Visual Studio will publish the app to the Web App. After the publish has finished, your browser window will launch, showing you your deployed website. 

> **Web App URLs**
>
> The deployed web app has a URL of *Web App Name*.azurewebsites.net. Remember this URL, because you'll be using it in later chapters.

One final note is to check the Azure Portal to see the App Service plan and Web App deployed to your resource group:

<img src="images/chapter1/deployed-webapp.png" class="img-override" />

This concludes the exercise. 

<div class="exercise-end"></div>