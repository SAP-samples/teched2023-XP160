# Exercise 3 - Connect Azure Function and UI5 app

# Goal

In this exercise, you will connect the Azure Function endpoint from [exercise 2](../exercise2/README.md) to the UI5 app to fetch the tracking information for your sales orders. 

> **Note** - The UI5 app you deployed in [exercise 1](../exercise1/README.md) already contains the necessary code to fetch the information. The only missing piece is the configuration of the destination.

## Exercise

### Task 1 - Update the destination

As you already created the destination including its configuration in [exercise 1](../exercise1/README.md) you must add the missing destination configuration for the Azure Function endpoint. Terraform will then apply this change and update the infrastructucture accordingly.

To achive this open the `main.tf` file in the folder [infra_exercise1](../../code/exercise1/infra_exercise1) and navigate to the section where you defined the destination to the S/4HANA system:

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

You must add a second entry into the array of destination objects with the data of the Azure Function. The entry basically is defined as:

```bash
{
   "Authentication"           = "NoAuthentication",
   "Name"                     = "tracking-info",
   "Description"              = "Connection to Public Azure Function endpoint",
   "ProxyType"                = "",
   "Type"                     = "Internet",
   "URL"                      = "<URL to your Azure Functions Endpoint>",
}
```

You must replace the placeholder of the `URL` with the value you received after your deplyoment of the Azure Function.

> **Note** - If you missed to note the URL down, you can also find it in the Azure Portal namely in your Azure Function app.

The final result should then look like this:

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
          },
          {
          {
            "Authentication"           = "NoAuthentication",
            "Name"                     = "tracking-info",
            "Description"              = "Connection to Public Azure Function endpoint",
            "ProxyType"                = "",
            "Type"                     = "Internet",
            "URL"                      = "https://...",
}  
          }
        ]
      }
    }
  })
}
```

Save the changes and execute a `terraform apply`. The resulting plan should contain the change of the destination resource. If this is the case acknowledege the apply by keying in `yes`.

After the successfull application of the change you should see two destinations in the destination service.

### Task 2 - Validate the availability of the destination 

Now it is time to validate that everything is working as expected. Open the UI5 app and check if the tracking informaton can be fetched from the Azure Function


## Summary

🎉 **Congratulations** 🎉 - You just successfully 

- provisioned the infrastrusture for a Sales Order App on SAP BTP including a connection to an SAP S/4HANA system hosted on Azure via the Private Link Service
- deployed the UI5 app to SAP BTP
- provisioned the infrastructure for an Azure Function on Azure
- deployed an Azure Function app to Azure 
- connected the Azure Fucntion to the UI5 app leveraging the Destination service on SAP BTP

by using Terraform ... in less than 90 minutes. Not too shaby, right.

What remains to say ... onwards and upwards with Terraform!