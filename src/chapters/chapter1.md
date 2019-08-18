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
    <b>Exercise</b>: Getting the workshop files
</h4>

Clone or download the `master` branch from [https://github.com/mikebranstein/terraform-workshop](https://github.com/mikebranstein/terraform-workshop).

Use this [link](https://github.com/mikebranstein/terraform-workshop/archive/master.zip) to download a zip file of the `master` branch.

<img src="images/chapter1/downloaded-zip.png" class="img-small" />

> **Unblock the .zip file!** 
>
> Don't open the zip file yet. You may need to unblock it first!

If you're running Windows, right-click the zip file and go to the properties option. Check the *Unblock* option, press *Apply*, press *Ok*. Don't worry that the image below has a different file name - it's the same process.

<img src="images/chapter1/unblock.gif" />

Now it's safe to unzip the file. 

<div class="exercise-end"></div>

### About Contoso University

The Contoso University web app is a small app that is used to manage the faculty, students, courses, and grades of Contoso University. It's not very advanced, but comes with pre-seeded data, and is ideal to demonstrate the concepts of this workshop. 

You won't be using it until later in the workshop, but it's good to have it downloaded now.

This completed the chapter.