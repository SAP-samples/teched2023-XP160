# Exercise 1 - Setup your SAP BTP Subaccount

In this exercise, we will connect an UI5 app running on SAP BTP to an SAP S/4HANA Cloud system running on Microsoft Azure.

## Exercise 1.0: Adapt file `variables.tf`

Switch to the tab with your GitHub Codespace and enter the following commands into the terminal:

```bash
clear
cd code/exercise1/infra_exercise1/
```

If you open the respective folder in the explorer pane, you can click on the `main.tf` file and see what it is inside that file.

![Screenshot of Codespace with main.tf](/exercises/exercise1/images/01_01_01.png)

Before you can start, you must provide some variables. Please open the `variables.tf` file in the `code/exercise1/infra_exercise` folder.

### Change `globalaccount`

Look for the section with the variable `globalaccount` and change the *default value* to the value of the subdomain of the global account.

![Screenshot of SAP BTP environment instance section](/exercises/exercise1/images/01_01_02b.png)

```terraform
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
  default     = "a0ab1ce3-9dab-48b8-9122-524f7fde1f28"
}
```

### Add `subaccount_id`

Look for the section with the variable `subaccount_id` and add a *default value*. That value is the subaccount ID from your BTP subaccount you saw in exercise 0.

You find the subaccount ID in the SAP BTP Cockpit in the overview of your subaccount

![Screenshot of SAP BTP subaccount overview](/exercises/exercise0/images/00_02_02.png)

Paste the ID into the `variables.tf` file as a default value for the variable `subaccount_id` .

```terraform
variable "subaccount_id" {
  type        = string
  description = "The subaccount id of the subaccount."
  default     = "<please look it up in the BTP cockpit>"
}
```

### Add `cf_org_id`

Look for the section with the `cf_org_id` and add a *default value*. That value is the Cloudfoundry org id from the Cloudfoundry environment instance.

To get it, switch to your BTP cockpit, get into your subaccount and copy the id you see in the `Cloud Foundry Environment` section behind the field `Org ID`.

![Screenshot of SAP BTP environment instance section](/exercises/exercise1/images/01_01_02.png)

Paste the ID into the `variables.tf` file as a default value for the variable `cf_org_id`.

```terraform
variable "cf_org_id" {
  type        = string
  description = "The Cloudfoundry org id in the subaccount."
  default     = "<paste Org ID here>"      
}
```

### Add `cf_org_name`

Look for the section with the `cf_org_name` and add a *default value*. That value is the Cloudfoundry org name from the Cloudfoundry environment instance.

To get it, switch to your BTP cockpit, get into your subaccount and copy the id you see in the `Cloud Foundry Environment` section behind the field `Org Name`.

![Screenshot of SAP BTP environment instance section](/exercises/exercise1/images/01_01_02a.png)

Paste the ID into the `variables.tf` file as a default value for the variable `cf_org_name`.

```terraform
variable "cf_org_name" {
  type        = string
  description = "The name of the Cloudfoundry organization"
  default     = "<paste Org name here>"      
}
```

### Change `region`

Change the *default value* for the `region` to `ap21`.

```terraform
variable "region" {
  type        = string
  description = "The region where the sub account shall be created in."
  default     = "ap21"
}
```

### Change `s4_resource_id`

Look for the section with the variable `s4_resource_id` and change the *default value* to the value, that the session instructors will give you.

```terraform
variable "s4_resource_id" {
  type        = string
  description = "The resource ID of the S/4HANA loadbalancer on Azure"
  default     = "<value provided by the session instructors>"
}
```


You are now ready for the first steps in Terraform. Save the changes and switch to the terminal and type-in the following commands followed by hitting the `return` key:

```bash
terraform init
```

You will get an output similar to this:

![Codespace terminal - initialization of Terraform](/exercises/exercise1/images/01_01_03.png)

This step fetches all Terraform providers that the Terraform CLI has detected in the Terraform scripts.

## Exercise 1.1: Create service instance for SAP Private Link for Azure

In a next step we will see how Terraform is `plan`ing the scripts. Type-in the following commands and hit the `return` key:

```bash
terraform plan
```

You should see a list of the planned steps for the Terraform script. If not check the error message and see if your terraform configuration is complete. If not adjust further and try again after a `terraform init -upgrade`.

> **Note** - If you get an error message here, this means, that you might not have completed the steps before correctly.

In the next step we will see how Terraform will apply the `plan` to your infrastructure. Type-in the following commands and hit the `return` key:

```bash
terraform apply
```

When asked, if you really want to execute the plan, you should confirm by typing `yes` and hit the `return` key.

Once the script is finished successfully, you should see the created private link instance in your subaccount.

> **Note** - be aware we configured Private Link auto-approval on the Azure subscription used in this hands-on session for requests coming from this SAP BTP global account. In your own scenarios you might want to approve manually or use other workflows.

![Screenshot of SAP Cockpit instance overview with the private Link service](/exercises/exercise1/images/01_01_04.png)

## Exercise 1.2: Create service key for private link

As a next step in the setup, you must create a service key for the private link service. You created the service in the Cloud Foundry environment, so you must now also create the service key using the Terraform Provider for Cloud Foundry i.e. the resource [cloudfoundry_service_key](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/service_key). Include the creation of the resource in the `main.tf` file after the creation of the service instance of the private link service:

```terraform
# ------------------------------------------------------------------------------------------------------
# 1.2.0 Create service key for private link
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_service_key" "privatelink" {
  name = "privatelink_cf_service_key"
  service_instance = ""
}
```

For the second parameter you must specify the ID of the service instance of the private link service. How do you get that. The service instance was created via a module:

```terraform
module "create_cf_service_instance_privatelink" {
  source                = "../../admin/modules/cloudfoundry/cf-service-instance"
  cf_space_id           = data.cloudfoundry_space.dev.id
  service_name          = "privatelink"
  service_instance_name = "salesorder-navigator-privatelink"
  plan_name             = "standard"
  parameters            = jsonencode({ "resourceId" = "${var.s4_resource_id}" })
}
```

So let us check the output that the module provides in the file `cf_service_instance_outputs.tf` in the directory `code/admin/modules/cloudfoundry/cf-service-instance` that is specified as `source` of the module. It has the content:

```terraform
output "id" {
  value       = cloudfoundry_service_instance.service.id
  description = "The id of the created service instance."
}
output "service_details" {
  value       = cloudfoundry_service_instance.service
  description = "All details of the created service instance."
}
```

That looks good, the ID is handed over to the caller of the module via the output `id`. Use this output in the `main.tf` file and specify the ID of the service instance:

```terraform
# ------------------------------------------------------------------------------------------------------
# 1.2.0 Create service key for private link
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_service_key" "privatelink" {
  name             = "privatelink_cf_service_key"
  service_instance = module.create_cf_service_instance_privatelink.id
}
```


Save the changes and execute the Terraform script again:

```bash
terraform apply
```

When asked, if you really want to execute the plan, you should confirm by typing `yes` and hit the `return` key.

Once the script is finished successfully, you should see the created service key in your subaccount.

![Screenshot of SAP Cockpit instance overview with the private Link service key](/exercises/exercise1/images/01_01_04a.png)

This key i.e. the credentials that it provides are needed for the next exercise to configure the destination towards the SAP S/4HANA system.

## Exercise 1.3: Create destination service + destination to S/4HANA Cloud system on Azure

To connect the SAP S/4HANA system that is running on Azure to the SAP BTP subaccount, you must create a destination service and a destination. The destination service is created via a module as for the private link service. The module is located in the directory `code/admin/modules/cloudfoundry/cf-service-instance`. Add the call of the module to the `main.tf` file after the creation of the service key. We use the plan `lite` and the technical name of the service is `destination`. Add the following code to the `main.tf` file:

```terraform
# ------------------------------------------------------------------------------------------------------
# 1.3.0 Create destination service + destination to S/4HANA Cloud system
# ------------------------------------------------------------------------------------------------------
module "create_cf_service_instance_destination" {
  source                = "../../admin/modules/cloudfoundry/cf-service-instance"
  cf_space_id           = data.cloudfoundry_space.dev.id
  service_name          = "destination"
  service_instance_name = "salesorder-navigator-destination"
  plan_name             = "lite"
  parameters = jsonencode()
}
```

This is the basic setup for the destination service, but you also want to add the destination to the S/4HANA system via private link to the service. The main ingredient is the URL provided by the service key we created in the previous exercise. This key contains the necessary information to construct the URL parameter as part of the credentials (see also [documentation](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/service_key#attributes-reference) of the resource)

> **Note** - If you want to take a look at the fields contained in the resource you can also check the `terraform.tfstate` file that is in your exercise folder and contains the Terraform state.

To achieve this you must add the following parameters to the module call:

```terraform
# ------------------------------------------------------------------------------------------------------
# 1.3.0 Create destination service + destination to S/4HANA Cloud system
# ------------------------------------------------------------------------------------------------------
module "create_cf_service_instance_destination" {
  source                = "../../admin/modules/cloudfoundry/cf-service-instance"
  cf_space_id           = data.cloudfoundry_space.dev.id
  service_name          = "destination"
  service_instance_name = "salesorder-navigator-destination"
  plan_name             = "lite"
  parameters = jsonencode({
    "HTML5Runtime_enabled" : "true",
    "init_data" : {
      "instance" : {
        "existing_destinations_policy" : "update",
        "destinations" : [
          {
            "Authentication"           = "BasicAuthentication",
            "Name"                     = "s4-on-azure",
            "Description"              = "SAP S/4HANA Connection via Private Link",
            "ProxyType"                = "PrivateLink",
            "Type"                     = "HTTP",
            "URL"                      = "http://${resource.cloudfoundry_service_key.privatelink.credentials.additionalHostname}:50000",
            "User"                     = "BPINST"
            "Password"                 = "${var.s4_connection_pw}"
            "HTML5.DynamicDestination" = "true"
            "sap-client"               = "100"
          }
        ]
      }
    }
  })
}  
```


As you can see we take the Password to access the SAP System in the Destination from the variable s4_connection_pw. Open the variables.tf file and look for the section with the variable `s4_connection_pw` and change the *default value* to the value, that the session instructors will give you for the password

```terraform
variable "s4_connection_pw" {
  type        = string
  description = "Password for the destination to the S/4HANA system on Azure"
  sensitive   = true
  default = "xxx"
}
```

Save the changes. 
Since we are now using a new module (`create_cf_service_instance_destination`), we also need to run `terraform init` to install all modules required by this configuration. 

```bash
terraform init
```


Then execute the Terraform script again:

```bash
terraform apply
```

When asked, if you really want to execute the plan, you should confirm by typing `yes` and hit the `return` key.

Once the script is finished successfully, you should see the created service instance in your service instance overview.

![Screenshot of SAP Cockpit instance overview with the Destination Service](/exercises/exercise1/images/01_01_04b.png)

Click on the Destination Service name to see the Destination details.

![Screenshot of SAP Cockpit instance with the Destination Details](/exercises/exercise1/images/01_01_04c.png)



## Exercise 1.4: Setup SAP Build Workzone, standard edition

As we want to host a UI5 application we need an application that can host this UI. We will use the *SAP Build Workzone, standard edition* to achieve this. This is an application so the resource we need is of the type [btp_subaccount_subscription](https://registry.terraform.io/providers/SAP/btp/latest/docs/resources/subaccount_subscription). As you can see from the documentation, the basic setup looks like this:

```terraform
resource "btp_subaccount_subscription" "build_workzone" {
  subaccount_id = 
  app_name      = "SAPLaunchpad"
  plan_name     = "standard"
}
```

Add this block into your `main.tf` file after the creation of the service instance for the destination service.

> **Note** - be aware that the app_name must be the technical name of the service which is in this case `SAPLaunchpad`.

Last thing you must add is the value for the subaccount ID that you can fetch from the variables. The final result of the block looks like this:

```terraform
resource "btp_subaccount_subscription" "build_workzone" {
  subaccount_id = var.subaccount_id
  app_name      = "SAPLaunchpad"
  plan_name     = "standard"
}
```

The subscription of the application will create the needed role collections to access the app. However, the roles collections will not be automatically assigned to your user. You must therefore add the admin role `Launchpad_Admin` to your user. The corresponding resource is given by the [btp_subaccount_role_collection_assignment](https://registry.terraform.io/providers/SAP/btp/latest/docs/resources/subaccount_role_collection_assignment). Add the following block to your `main.tf`:

```terraform
resource "btp_subaccount_role_collection_assignment" "jd" {
  subaccount_id        = 
  role_collection_name = "Launchpad_Admin"
  user_name            = 
}
```

The missing parameters can be filled via the available variables. Add them to the code. The result should look like this:

```terraform
resource "btp_subaccount_role_collection_assignment" "launchpad_admin" {
  subaccount_id        = var.subaccount_id
  role_collection_name = "Launchpad_Admin"
  user_name            = var.username
}
```

Are we finished yet? How does Terraform know that it must wait with the execution of this resource until the app subscription is finished?

In general, the Terraform framework will try to execute as many actions on the resources as possible. In the planning phase it considers the dependencies that are *implicitly* defined in your `main.tf` file like using the output of one resource as input for the next one. But in the case of the assignment of role collections we have a dependency to the app subscription, but we do not have any implicit dependency that Terraform could detect. How can we solve that?

Terraform provides a special block for this scenario namely the `depends_on` argument ([documentation](https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on)). With this we can *explicitly* model the dependencies between resources that Terraform must take into account when calculating the execution plan of the resource provisioning.

In our scenario this means that you must specify the dependency to the app subscription as:

```terraform
resource "btp_subaccount_role_collection_assignment" "launchpad_admin" {
  subaccount_id        = var.subaccount_id
  role_collection_name = "Launchpad_Admin"
  user_name            = var.username
  depends_on           = [btp_subaccount_subscription.build_workzone]
}
```

Before we can run terraform apply again, we need to add a required provider. Open the `provider.tf` files and search for the `btp` in the `required_providers` sections. 
Add

```terraform
     btp = {
       source  = "SAP/btp"
       version = "0.5.0-beta1"
     }
```

The provider needs the `globalaccount` variable, which we need to reference from our `variables.tf` file updated before. So make sure to add that as well to the `provider.tf` file.

```terraform
 provider "btp" {
   globalaccount = var.globalaccount
 }
```

The result should look like this:
![Screenshot of provider.tf file](/exercises/exercise1/images/01_01_04d.png)

Save the changes and and run:
```bash
terraform init
```

Now you can add the two new resources to your setup as in the previous step. Save the changes and execute the Terraform script:

```bash
terraform apply
```

When asked, if you really want to execute the plan, you should confirm by typing `yes` and hit the `return` key.

Once the script is finished successfully, you should see the created app subscription as well as the role collection assignment to your user.

![Screenshot of provider.tf file](/exercises/exercise1/images/01_01_04e.png)

With that we have the necessary infrastructure in place and can proceed to deploy the UI5 application.

## Exercise 1.5: Deploy the UI5 application

We already prepared the application in the repository under `code/exercise1/salesorder-navigator`. This folder contains the sources as well as the built MTA file in the subfolder `mta_archives`.

In general, the provider for Cloud Foundry provides a resource that represents a `cf push` execution. As we are using a mta file, we would need a resource that mimics a `cf deploy` command. As this is specific to the SAP ecosystem, the provider does not provide such a resource. How to proceed?

You will sometimes run into such scenarios when using Terraform providers maybe as a limitation that will be removed in newer releases or as a permanent issue. Terraform offers a workaround for such scenarios via so called [*Provisioners*](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax).

We must make explicit calls to the CF CLI, so the [local-exec Provisioner](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec) seems to be a good fit for our scenario.

> **Note** - Using provisioners is **always** a last resort if no other options provided by Terraform can be used to overcome the limitation. The usage comes with some drawbacks that must be considered carefully.

As we must execute it standalone we also must leverage a pseudo resource, the [*null_resource*](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) provided by Hashicorp.

To execute the deployment add the following code to your `main.tf` file:

```terraform
resource "null_resource" "cf_app_deploy" {
  provisioner "local-exec" {
    command = "cf login -a https://api.cf.${var.region}.hana.ondemand.com -u ${var.username} -p ${var.cf_password}"
  }
  provisioner "local-exec" {
    command = "cf target -o ${var.cf_org_name} -s ${data.cloudfoundry_space.dev.name}"
  }
  provisioner "local-exec" {
    command = "cf deploy ../salesorder-navigator/mta_archives/archive.mtar"
  }
  depends_on = [btp_subaccount_subscription.build_workzone, module.create_cf_service_instance_destination, module.create_cf_service_instance_privatelink, cloudfoundry_service_key.privatelink]
}
```

The code is quite comprehensive as it represents the steps you would execute in the terminal to trigger the deployment via the CF CLI.

> **Note** - Any tool or CLI that you want to execute via the `local-exec` Provisioner must be installed on your machine. We already did so when setting up the dev container that you use.

The only think that is missing in the setup is the `var.username` and `var.cf_password`. It is defined in the `variables.tf` file but is never filled with a value. Open the `variables.tf` file and update the `variable "username"` and `variable "cf_password"` with the username and password provided to you. 

```terraform
variable "username" {
  type        = string
  description = "The user that should be assigned all necessary roles."
  default = "XP160-0000ZZ@education.cloud.sap"
}
```
and

```terraform
variable "cf_password" {
  type        = string
  description = "The user that should be assigned all necessary roles."
  default = "Password ZZZ"
}
```

Save and close the file.

> **Note** - As the variable `cf_password` is marked as `sensitive` it will not show up in any terminal output of Terraform.

Now we are ready to go to deploy the app. As we have added a new resource, we must first update the basic setup. Execute the following command:

```bash
terraform init -upgrade
```

After that execute the Terraform script to deploy the app:

```bash
terraform apply
```

When asked, if you really want to execute the plan, you should confirm by typing `yes` and hit the `return` key.

## Exercise 1.6: Open the UI5 application

After successful execution open the SAP BTP Cockpit, navigate to your subaccount and open the app located in the `HTML5 Applications` section from the top level screen.

![Screenshot of HTML5 applications section](/exercises/exercise1/images/01_01_05.png)

The app should open and look like this (note the "Request from Azure" button will start working once we have completed exercise 3"):

![Screenshot of UI5 app - master detail view on sales orders](/exercises/exercise1/images/01_01_06.png)

## Summary

You've now confirmed access to your Subaccount. We continued using this space to deploy an SAP Fiori app, which is connected to an SAP S/4HANA Cloud, private edition instance running on Azure. Since both the SAP Business Technology Platform and the SAP system are running on Azure, we were able to use SAP Private Link Service to make the connection even more secure and ensuring that data never leaves the Azure backbone.  

Continue to - [Exercise 2 - Add Tracking Information to the Sales Order](../exercise2/README.md)
