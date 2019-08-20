## Managing Terraform State

In the last chapter, you had to delete Azure resources before redeploying with Terraform. Deleting resources is ok in a workshop, but it's not going to fly in production -- imagine that you had to delete your productioni database everytime you wanted to deploy Terraform. Ridiculous. Luckily, Terraform provides you with a way to manage this mischief.

In this chapter, you'll learn:
- the importance of Terraform state files
- what a Terraform backend is
- how to store and organize state files

### Terraform State 

Up until now, you've been using Terraform to deploy resources from the command line by running *terraform apply*. You may have noticed that a *terraform.tfstate* file was created and updated each time you ran Terraform. What's up with that file?

That file is called a Terraform state file, but what's it for?

Terraform must store state about your managed infrastructure and configuration. This state is used by Terraform to map real world resources to your configuration, keep track of metadata (like resource ids, names, etc.), and to improve performance for large infrastructures.

#### Why state files important

Imagine you're trying to create a virtual machine using Terraform, and the first time you run *terraform apply*, a VM is created and named *myVM*. Now, you update your Terraform code, adding another resource, then re-run *terraform apply*. Now, imagine that Terraform doesn't know anything about the environment it's deploying to. What should it do? Create a new VM named *myVM*?Update the existing VM? How does it know that VM already exists, and how does it know that VM is the same VM you referenced in your code?    

Terraform answers these questions by keeping a cached environment configuration within a file - the state file. When *terraform apply* is run, it examines the state file, and reads the environment configuration, then determines whether it will create, update, or delete resources. Even though Terraform can query the destination environment to see if resources exist, and create a plan from the *live* information, it's much faster to cache the environment state and work from it locally. 

There are other benefits from managing state in a local file, but we're not goign to cover those in today's workshop. 

#### State file specifics.

Terraform state is stored (by default) in a local file named "terraform.tfstate", but it can also be stored remotely, which works better in a team environment. In fact, when you integrate Terraform into a CICD pipeline, you need to store state files in a central location. 

### Storing Terraform state remotely

Just like Terraform has providers for integrating with various platforms (Azure, AWS, VMWare, HyperV, etc.), it has providers to integrate with various *backends*.

> **What is a backend?**
>
> A *backend* in Terraform determines how state is loaded and how an operation such as apply is executed. This abstraction enables non-local file state storage, remote execution, etc. For example, a backend could be a Windows or Linux file share, an Azure or AWS storage account, or a repository, like Artifactory or Azure DevOps. 

By default, Terraform uses the "local" backend, which is the normal behavior of Terraform you're used to (this is what created the terraform.tfstate files previously). 

Here are some of the benefits of backends:

1. Working in a team: Backends can store their state remotely and protect that state with locks to prevent corruption. Some backends such as Terraform Cloud even automatically store a history of all state revisions.

2. Keeping sensitive information off disk: State is retrieved from backends on demand and only stored in memory. If you're using a backend such as Azure storage accounts or Amazon S3, the only location the state ever is persisted is in the storage account or S3.

3. Remote operations: For larger infrastructures or certain changes, terraform apply can take a long, long time. Some backends support remote operations which enable the operation to execute remotely. You can then turn off your computer and your operation will still complete. Paired with remote state storage and locking above, this also helps in team environments.

Backends are completely optional. You can successfully use Terraform without ever having to learn or use backends. However, they do solve pain points that afflict teams at a certain scale. If you're an individual, you can likely get away with never using backends.

> **Will we be using a backend in the workshop?**
>
> Yes. In this workshop, you'll be using an Azure storage account as the backend. 

Ok, enough talking. Let's start doing.

### Storing state remotely

In this section, you'll be updating your Terraform code to configure a backend. But, before we can do that, we'll need to create an Azure storage account.

> **To Terraform or not to Terraform?**
>
> This *IS* the question for backends. Now that you know of the importance of storing Terraform state files in a backend, should you use Terraform to create the backend store? To me, it doesn't matter. Typically, DevOps teams already have a preferred platform for data/artifact storage (like an Azure DevOps repository or Artifactory). In this case, your backend exists already. If you're just jumping into Terraform, it's ok to manually create your backend data store - just remember, it should be backed up!

Let's create that storage account.

<h4 class="exercise-start">
    <b>Exercise</b>: Create a Storage Account
</h4>

Login to the Azure Portal, and open the Cloud Shell, like you did earlier in the workshop:

<img src="images/chapter0/cloud-shell.png" class="img-override" />

Create a resource group named terraform-state-rg:

```bash
az group create --location eastus --name terraform-state-rg
```

Create a storage account in the resource group. Be sure to replace {storage-account-name} with a random storage account name (It must be unique!). For example, I used *tfstatemeb2019*:

```bash
az storage account create --name {storage-account-name} --resource-group terraform-state-rg --location eastus
```

Create a container in your storage account to hold your dev and prod statefiles:

For dev:

```bash
az storage container create --account-name {storage-account-name} --name dev
```

...and prod:

```bash
az storage container create --account-name {storage-account-name} --name prod
```

> **Organizing State Files**
>
> As you store your state files, it's important to organize them so yhou don't accidentally overwrite or lose it. We're using a simple naming scheme of *dev* and *prod* to store ours, but you may need something more sophistocated in the real world.

Now that your storage account is created, navigate to the storage account *Access control (IAM)* page in the Azure portal:

<img src="images/chapter4/storage-iam.png" class="img-small" />

Click *Role Assignments*, then *Add* a Role Assignment to give your virtual machine access to read/write data to the storage account.

- Role: Storage Blob Data Contributor
- Assign Access to: Virtual Machine
- Subscription: your Azure subscription

Then, select the VM name you're using for the workshop.

Click *Save*.

<img src="images/chapter4/role-assignment.png" class="img-small" />

This concludes the exercise.

<div class="exercise-end"></div>

Now that we have a storage account, let's update our Terraform code to use it.

<h4 class="exercise-start">
    <b>Exercise</b>: Create a Storage Account
</h4>

Before we get started, collect the following information:

1. Storage account name: this is the name you gave to the account you created in the previous exercise. Mine was *tfstatemen2019* - yours will be different.

2. Subscription ID: The id of your Azure subscription (you should already have this saved in your main.tf file).

3. Tenant ID: The id of your Azure tenant (you should already have this saved in your main.tf file).

#### Updating the dev main.tf file

Open your main.tf for dev and add the following terraform code to the top of the file.

```json
terraform {
  backend "azurerm" {
    storage_account_name = "storage-account-name"
    container_name       = "dev"
    key                  = "terraform.tfstate"
    use_msi              = true
    subscription_id  = "00000000-0000-0000-0000-000000000000"
    tenant_id        = "00000000-0000-0000-0000-000000000000"
  }
}
```

Update the code by chaning the values for `storage_account_name`, `subscription_id`, and `tenant_id`.

#### Updating the prod main.tf file

Open your main.tf for dev and add the following terraform code to the top of the file.

```json
terraform {
  backend "azurerm" {
    storage_account_name = "storage-account-name"
    container_name       = "prod"
    key                  = "terraform.tfstate"
    use_msi              = true
    subscription_id  = "00000000-0000-0000-0000-000000000000"
    tenant_id        = "00000000-0000-0000-0000-000000000000"
  }
}
```

Update the code by chaning the values for `storage_account_name`, `subscription_id`, and `tenant_id`.

#### Testing your changes

Navigate to the dev directory, where main.tf exists. Initialize Terraform.

```bash
terraform init
```

> **But I already initialized once**
>
> Yes, that is true, but since you've updated the backend configuration, you'll need to re-initialize Terraform to ensure it talks to your backend.

Apply the changes:

```bash
terraform apply
```

Verify that Terraform ran successfully, then check the storage account to ensure a terrform.tfstate file exists in the *dev* blob container:

<img src="images/chapter4/tfstate.png" class="img-small" />

> **Don't forget about prod!***

Before you continue, re-initialize prod and run *terraform apply*. Validate the terraform.tfstate file exists in the prod blob container before continuing.

This concludes the exercise.

<div class="exercise-end"></div>

In this chapter, you learned why Terraform state files are important, and how to configure a Terraform backend to automatically store and retreive the state file. 

This concludes the chapter.