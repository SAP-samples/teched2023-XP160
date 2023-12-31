# Exercise 0 - Prepare your development environment

## Exercise 0.1: Get the code for this session into VS Code

We will use GitHub [Codespaces](https://docs.github.com/codespaces/overview) as integrated development environment for this workshop. Access the Codespace following these steps:

1. Open the [GitHub repository for XP160](https://github.com/SAP-samples/teched2023-XP160).

    ![Screenshot of GitHub repository XP160](/exercises/exercise0/images/00_01_01.png)

    > **Note** - If you do not yet have a user on GitHub, go to [https://github.com/](https://github.com/signup) and Sign-up to create a new user using an exiting email-address.

2. Click on this button and create the code space:

   [![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=685140118&skip_quickstart=true&machine=basicLinux32gb&geo=SoutheastAsia&devcontainer_path=.devcontainer%2Fdevcontainer.json)

    This will take a few minutes. Be patient 🙂

    ![Screenshot of navigation to Codespace creation in the repository XP160](/exercises/exercise0/images/00_01_02.png)

3. While the Codespace is created for you, you will see this screen

    ![Screenshot of setup screen for Codespace](/exercises/exercise0/images/00_01_03.png)

4. Once all is done, you are in your Codespace.

    > **Note** - GitHub codespaces are free for a certain amount of time per month. For the hands-on session the free time is more than enough. **Don't forget to delete your codespace again after the hands-on session!**

    ![Screenshot of GitHub Codespace view on the repository XP160](/exercises/exercise0/images/00_01_04.png)

## Exercise 0.2: Get the ID of your SAP BTP subaccount

1. Get the credentials (username and password) from the instructor of this hands-on session. Each participant will get access to one SAP BTP subaccount.

2. Open the [SAP BTP global account for XP160](https://emea.cockpit.btp.cloud.sap/cockpit/#/globalaccount/a0ab1ce3-9dab-48b8-9122-524f7fde1f28/) in a **new tab** of your web browser. You will have to use the credentials provided to you by the instructors.

    ![Screenshot of list of subaccounts](/exercises/exercise0/images/00_02_01.png)

3. Select your sub account and copy the `Subaccount ID` into the clipboard.

    ![Screenshot of SAP BTP Subaccount overview](/exercises/exercise0/images/00_02_02.png)

## Exercise 0.3: Add environment variables to your Codespace

For the Terraform provider to work you must export the following environment variables in your Codespace. You can do this by opening a terminal and exporting the following variables.

> **Note** - If the Terminal windows is not open, you can open it from Codespaces via the hamburger menu

![Screenshot of SAP BTP Subaccount overview](/exercises/exercise0/images/00_02_03.png)

```bash
export BTP_USERNAME=<your SAP BTP username>
export BTP_PASSWORD='<your SAP BTP password>'
export CF_USER=<your SAP BTP username>
export CF_PASSWORD='<your SAP BTP password>'
```

Validate that the values are set via `echo $BTP_USERNAME` and `echo $BTP_PASSWORD`.

![Screenshot of SAP BTP Subaccount overview](/exercises/exercise0/images/00_02_04.png)

## Summary

You've now prepared your development environment and have all information to finally start using Terraform.  

Continue to - [Exercise 1 - Setup your SAP BTP Subaccount](../exercise1/README.md)
