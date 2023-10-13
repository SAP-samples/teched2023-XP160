# Exercise 1 - Setup your SAP BTP Supaccount

In this exercise, we will create...

## Exercise 1.1: Get the code for this session into VS Code

1. Open VS Code on your machine.

2. Open the [GitHub repository for XP160](https://github.com/SAP-samples/teched2023-XP160).

![](/exercises/ex1/images/01_01_02.png)

3. Press the `Code` button and click on the copy-and-paste icon on the right of the link.

![](/exercises/ex1/images/01_01_03.png)

4. Switch to VS Code and click on `Clone Git Repository`
 
![](/exercises/ex1/images/01_01_04.png)

5. Paste the link you've copied (e.g. `https://github.com/SAP-samples/teched2023-XP160`) from step 3 into the input field and hit the `Enter` key.

![](/exercises/ex1/images/01_01_05.png)

6. Select a place in the folder `XXXX`

7. Now you should see the code inside VS Code.

## Exercise 1.2: get the ID of your subaccount

1. Get the credentials from the instructor of this hands-on session

    You will get the username and your password from the session instructors. Each participant will get access to one BTP subaccount.

2. Open the [SAP BTP global account for XP160](https://emea.cockpit.btp.cloud.sap/cockpit/#/globalaccount/a0ab1ce3-9dab-48b8-9122-524f7fde1f28/) in the web browser of your machine
    You will have to use the credentials to login provided to you.
![List of Subaccounts](/exercises/ex1/images/01_01_02a-Subaccounts.png)

3. Select your sub account and copy the `Subaccount ID` into the clipboard.

![](/exercises/ex1/images/01_02_03.png)


## Summary

You've now confirmed access to your Subaccount. We will  continue to use this space and deploy and SAP Fiori app which is connected to an SAP System running on Azure. Since both the SAP Business Technology Platform and the SAP system is running on Azure, we can use SAP Private Link Service to make the connection even more secure and ensuring that data never leaves the Azure backbone.  

Continue to - [Exercise 2 - Exercise 2 Description](../ex2/README.md)

