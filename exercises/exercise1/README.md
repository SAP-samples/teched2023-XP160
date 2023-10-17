# Exercise 1 - Setup your SAP BTP Subaccount

In this exercise, we will connect an UI5 app running on SAP BTP to an SAP S/4HANA Cloud system running on Microsoft Azure.

## Exercise 1.0: Adapt file `variables.tf`

Switch to the tab with your GitHub codespace and enter the following commands into the terminal:

```bash
clear
cd code/exercise1/infra_exercise1/
```

If you open the respective folder in the explorer pane, you can click on the `main.tf` file and see what it is inside that file.

![Screenshot of Codespace with main.tf](/exercises/exercise1/images/01_01_01.png)

Before you can start, you must provide some variables. Please open the `variables.tf` file in the respective folder.

### Add `subaccount_id`

Look for the section with the varable `subaccount_id` and add a *default value*. That value is the subaccount ID from your BTP subaccount you saw in exercise 0.

You find the subaccount ID in the SAP BTP Cockpit in the overview of your Subaccount

![Screenshot of SAP BTP subaccount overview](/exercises/exercise0/images/00_02_01.png)

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

### Change `globalaccount`

Look for the section with the variable `globalaccount` and change the *default value* to the value of the subdomain of the global account.

```terraform
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
  default     = "<paste subdomain of the global account here>"
}
```

**You are now ready for the first steps in Terraform**

Switch to the terminal and type-in the following commands followed by hitting the `return` key:

```bash
terraform init
```

You will get an output similar to this:

![Codespace terminal - initialization of Terraform](/exercises/exercise1/images/01_01_03.png)

This step fetches all Terraform providers that the Terraform CLI has detected in the Terraform scripts.

## Exercise 1.1: Create service instance for SAP private link

In a next step we will see how Terraform is `plan`ing the scripts. Type-in the following commands and hit the `return` key:

```bash
terraform plan
```

You should see a list of the planned steps for the Terraform script.

> **Note** - If you get an error message here, this means, that you might not have completed the steps before correctly.

In the next step we will see how Terraform will apply the `plan` to your infrastrucure. Type-in the following commands and hit the `return` key:

```bash
terraform apply
```

When asked, if you really want to execute the plan, you should confirm by typing `yes` and hit the `return` key.

Once the script is finished successfully, **you should see the created private link instance in your subaccount**.

![Screenshot of SAP Cockpit instance overview with the private Link service](/exercises/exercise1/images/01_01_04.png)

## Exercise 1.2: Create service key for private link

As a next step in the setup, you must create a service key for the private link service. Xou cretaed the service in the Cloud Foundry environment, so you must now also create the service key using the Terraform Provider for Cloud Foundry i.e. the resource [cloudfoundry_service_key](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/service_key). Include the creation of the resource in the `main.tf` file after the creation of the service instance of the private link service:

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
  source       = "../../admin/modules/cloudfoundry/cf-service-instance"
  cf_space_id  = data.cloudfoundry_space.dev.id
  service_name = "privatelink"
  plan_name    = "standard"
  parameters   = jsonencode({ "resourceId" = "${var.s4_resource_id}" })
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

Once the script is finished successfully, **you should see the created service key in your subaccount**.

## Exercise 1.3: Create destination service + destination to S/4HANA Cloud system

To connect the SAP S/4HANA system that is running on Azure to the SAP BTP subaccount, you must create a destination service and a destination. The destination service is created via a module as for the private link service. The module is located in the directory `code/admin/modules/cloudfoundry/cf-service-instance`. Add the call of the module to the `main.tf` file after the creation of the service key. We use the plan `lite` and the technical name of the service is `destination`. Add the following code to the `main.tf` file:

```terraform
# ------------------------------------------------------------------------------------------------------
# 1.3.0 Create destination service + destination to S/4HANA Cloud system
# ------------------------------------------------------------------------------------------------------
module "create_cf_service_instance_destination" {
  source       = "../../admin/modules/cloudfoundry/cf-service-instance"
  cf_space_id  = data.cloudfoundry_space.dev.id
  service_name = "destination"
  plan_name    = "lite"
  parameters = jsonencode()
}
```

This is the basic setup for the destination service, but you also want to add the destination to the S/4HANA system via private link to the service. To achieve this you must add the following parameters to the module call:

```terraform
# ------------------------------------------------------------------------------------------------------
# 1.3.0 Create destination service + destination to S/4HANA Cloud system
# ------------------------------------------------------------------------------------------------------
module "create_cf_service_instance_destination" {
  source       = "../../admin/modules/cloudfoundry/cf-service-instance"
  cf_space_id  = data.cloudfoundry_space.dev.id
  service_name = "destination"
  plan_name    = "lite"
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
            "URL"                      = "http://93549d77-6851-4178-ba3c-18720c5e5638.p3.pls.sap.internal:50000",
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

## Exercise 1.4: Setup SAP Build Workzone, standard edition

xxxx.

## Exercise 1.5: Deploy the UI5 app

xxxx.

## Summary

You've now confirmed access to your Subaccount. We will  continue to use this space and deploy and SAP Fiori app which is connected to an SAP System running on Azure. Since both the SAP Business Technology Platform and the SAP system is running on Azure, we can use SAP Private Link Service to make the connection even more secure and ensuring that data never leaves the Azure backbone.  

Continue to - [Exercise 2 - Add Tracking Information to the Sales Order](../exercise2/README.md)