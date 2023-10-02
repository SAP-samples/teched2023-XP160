# Exercise 2 - Add Tracking Information to the Sales Order

## Goal

In this exercise, you will add tracking information to the sales order. This will be done by adding a [Azure Function](https://learn.microsoft.com/azure/azure-functions/functions-overview?pivots=programming-language-javascript) to the solution. The Azure Function is a serverless offering. It will return the current tracking status of the sales order based on the tracking ID.

> **Note** - We do not call any 3rd party API for this, instead the call is mocked and fixed values are returned.

## Technical Background

To achieve this goal, you will complete the following tasks:

- Deploy the necessary resources like an `Azure Function App` and a `Azure Storage Account` to your Azure subscription.
- Deploy the Azure Function code.

Both steps will be handled in a self-contained way by using the *Azure Developer CLI*.

> **Note** - If you want to learn more about the Azure Developer CLI, you find the documentation [here](https://learn.microsoft.com/azure/developer/azure-developer-cli/overview)

### What is provided for you?

As in exercise one you do not start from scratch. All CLI tools are already installed and the source code of the Azure Function is available. You find all necessary files in the `azfunc` folder.

The file structure looks like this:

- `azfunc`: Root folder that comprises the complete `azd` project
  - `azure.yaml`: The `azd` manifest file
  - `src`: The folder that contains the source code of the Azure Function
  - `infra_exercise`: The folder that contains the infrastructure setup for the exercise
  - `infra_solution`: The folder that contains a sample solution for the infrastructure setup

You will focus on adding the necessary parts to your infrastructure setup in the files located in `infra_exercise`.

### Basic `azd` setup

Before starting with the exercise you will need to authenticate against your Azure subscription.
To do so open a terminal and key in:

```bash
azd login
```

This will trigger a login flow via your browser. After successful login you will be able to use the `azd` CLI.

As we are also making use of the `az` CLI (the one without the "d" 😉) behind the scenes, you will need to authenticate against your Azure subscription as well. To do so open a terminal and key in:

```bash
az login
```

This will trigger a login flow via your browser. After successful login you are all set to start with the exercise.

## Exercise

Now it your turn. You will need to complete the tasks described in the following sections to successfully deploy your Azure Function.

> **Note** - In case you are running into issues you can always check the sample solution in the `infra_solution` folder.

### Task 0 - Familiarize yourself with the configuration

Before starting with the exercise you should take a look at the configuration files that are provided for you. You will find them in the `infra_exercise` folder.

As a rough guideline you can follow the following steps:

- What is contained in the setup defined in `main.tf`?
- What parameters are used for the setup
- Are all resources directly referenced in `main.tf` or is the setup done via modules?
- Where are the modules located?
- Which module is used to deploy the Azure Function?

After that you should have a rough understanding of the setup and the configuration files and be able to start the first task.

### Task 1 - Provide the right variables

First we want to define the name of the Function App to match your user. To do so open the `variables.tf` file and add a default value to the following variable:

```hcl
variable "azure_function_name" {
  description = "The name of Azure Functions"
  type        = string
}
```

The result should look like this with `XXX` being your user number:

```hcl
variable "azure_function_name" {
  description = "The name of Azure Functions"
  type        = string
  default     = "techedxp160-userXXX"
}
```

Save the changes and close the file.

> **Note** - What other options do you have to set the variable in Terraform?

### Task 2 - Add the Azure Function setup

Go back to the file `main.tf`. At the bottom of the file you find some commented out code that is a placeholder for the Function App creation.

```hcl
# ------------------------------------------------------------------------------------------------------
# Deploy Function app
# ------------------------------------------------------------------------------------------------------
#module "azurefunction" {
#  source                                 = "./modules/function"    
#  storage_account_name                   = module.storage.STORAGE_ACCOUNT_NAME
#  storage_account_access_key             = module.storage.STORAGE_ACCOUNT_ACCESS_KEY
#  application_insights_connection_string = module.applicationinsights.APPLICATIONINSIGHTS_CONNECTION_STRING
#  service_plan_id                        = module.appserviceplan.APPSERVICE_PLAN_ID
#}
```

Remove the comments and save the file.

Hmmm, this does not look like a complete setup. It seems that we are missing some information. But where can we get it from?

We are using a module here, so first check the module folder for the Azure Functions App which is located under `/azfunc/infra_exercise/modules/function`. Let us first check the variables that need to be set. They are defined in the file `function_variables.tf`.

Looks like the following parameters are missing in the `main.tf` file:

- `location`
- `rg_name`
- `tags`
- `function_name`

How can we find the values for these parameters? Let us compare the other modules in the `main.tf` file as well as the `variables.tf` to find the missing pieces.

Okay, this seems to be the missing information:

- `location`: This can be fetched via the variable `location` in `variables.tf`
- `rg_name`: This can be fetched via the output parameter `name` of the Terraform resource `azurerm_resource_group.rg.name`
- `tags`: This can be fetched via the output parameter `tags` of the Terraform resource `azurerm_resource_group.rg.name`
- `function_name`: This can be fetched via the variable `azure_function_name` in `variables.tf`

Filling the missing information into the `main.tf` file should result in the following code:

```hcl
# ------------------------------------------------------------------------------------------------------
# Deploy Function app
# ------------------------------------------------------------------------------------------------------
module "azurefunction" {
  source                                 = "./modules/function"
  location                               = var.location
  rg_name                                = azurerm_resource_group.rg.name
  tags                                   = azurerm_resource_group.rg.tags
  storage_account_name                   = module.storage.STORAGE_ACCOUNT_NAME
  storage_account_access_key             = module.storage.STORAGE_ACCOUNT_ACCESS_KEY
  application_insights_connection_string = module.applicationinsights.APPLICATIONINSIGHTS_CONNECTION_STRING
  service_plan_id                        = module.appserviceplan.APPSERVICE_PLAN_ID
  function_name                          = var.azure_function_name
}
```

Great! It seems that our setup of the resources is complete now. But how can we be sure?

### Task 3 - Check the planned deployment

It is time to check what will be deployed to your Azure subscription. To do so, you can use the `azd provision --preview` command. This command will show you the planned infrastructure deployment.

```bash
azd provision --preview
```

When calling it the first time you will be asked to enter some information that is needed by `azd` namely:

- A name for your environment:

   ```bash
   ? Enter a new environment name: [? for help]
   ```

   Enter the following values and replace `XXX` with your user number:

   ```bash
   techedxp160-userXXX
   ```

- A Azure Subscription:

   ```bash
   ? Select an Azure Subscription to use:  [Use arrows to move, type to filter]
   ```

   Select the subscription you want to use.

- A location for your Azure resources:

   ```bash
   ? Select an Azure location to use:  [Use arrows to move, type to filter]
   ```

   Select the subscription you want to use.

After that the already known `terraform plan` is executed. Check the output and make sure that the planned deployment lists the resources you would expect.

### Task 4 - Just deploy it

Ready, set, go - time to deploy your Azure Function via one command (to rule them all):

```bash
azd up
```

Follow the output of the command to check what is happening. Maybe you will even be rewarded with a little ASCII firework after the infrastructure is provisioned.

The last output will be the URL of your Azure Function. Copy it to your clipboard, you will need it later when updating the destination in SAP BTP.

### Task 5 - Check the deployment

Navigate to the Azure portal and check your resource group for the deployed resources. You should see the following resources:

**TODO**: Add screenshot

![Azure Portal - Overview Resource Group](./images/02_01_0010.png)

## Summary

You successfully deployed the Azure Function to your Azure subscription. You can now use the Azure Function to retrieve the tracking status of a sales order.

> **Note** - Asking yourself where the Terraform-relevant information is hiding from you? Take a look at the `.azure` folder that was created in your first call of `azd`.
