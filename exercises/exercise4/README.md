# Exercise 4 - Cleanup

## Goal

Now the fun part starts that you probably should not do in production: Destroy all the resources you created in the previous exercises.

Terraform makes this really easy. This is really handy for sandbox environments where you want to get rid of all the resources you created after having played around with them.

## Task 1 - Destroy the resources in SAP BTP

Navigate to the folder `code/exercise1/infra_exercise1`. To destroy the resources in SAP BTP, run the following command:

```bash
terraform destroy
```

The resulting plan should show that all resources will be deleted. If this is the case acknowledge the apply by keying in `yes`.

Terraform will now tear down all resources in SAP BTP. This will take a few minutes. No need to wait for the process to finish. You can already start with the next task.

## Task 2 - Destroy the resources in Azure

Open a second terminal and navigate to the folder `code/exercise2`. To destroy the resources in Azure, run the following command:

```bash
azd down
```

The resulting plan should show that all resources will be deleted. If this is the case acknowledge the apply by keying in `yes`.

Terraform will now tear down all resources in Azure. This will take a few minutes.

## Task 3 - Delete the GitHub Codespace

Once the resources in SAP BTP and Azure are deleted, you can delete the GitHub Codespace. To do so, follow the instractions in the offical [documentation](https://docs.github.com/en/codespaces/developing-in-codespaces/deleting-a-codespace#deleting-a-codespace).

> **Note** Be aware that even if your Codespace is stopped costs will apply due to the storage your Codespace needs. You must delete the Codespace to avoid any further costs.

## Summary

With that you really reached the end of this workshop. All resources including the Codespace are deleted.

**Enjoy SAP TechEd 2023 and have fun with Terraform!**