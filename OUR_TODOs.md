Focus: Create or enhance Terraform scripts

Part 1: Terraform CLI
Skeleton for TF script 
CF Environment
CF Space
CF Service Instance Private Link (Resource ID of Private Link Service)
CF App Deployment for Custom Fiori App
Destination Service Instance in CF Space (IP must be added into config, pw, user S/4); maybe manual steps needed for assigning hostname and setting up trust if IP does not work

Constraint no SSL, just http; Auto Approve for Private Link request

-> "Fill in the gaps"
Part 2 (Azure Function): azd (needed for app deployment)
• SAP BTP
    • CF App Deployment
    • Service Instance Private Link
    • Destination Service Instance update, add second configuration
• Azure
    • Creation of resource group (per participant)
    • Azure Function App (Web app) as proxy to Tracking APIs (we use e.g. DHL)/mock
    • Deploy App (azd needed) ~15 min

What needs to be provided by us before HandsOn:
• Basic TF setup for preconfigured subaccounts for participants including necessary entitlements. Participant is subaccount admin only. 
• S/4HANA on Azure (predeployed)
• Subaccount 
    • If no issues: 
    • If issues with Private Link service instance creation: Subaccount including CF org and space and private link instance must be pre-provided
• 2 Fiori Apps: 1x "Standard" Sales Order, 1x Custom with Azure Function call for tracking 

Constraints:
Preferred region: US (west and east)

IMPORTANT: THURSDAY IS UPDATE DAY! FREEZE?

Introduction/Setting the stage: ~25 min
Exercise 1 (usage with SAP): ~ 30 min
Build Fiori app to display sales orders  / products (master/detail)
Embed Fiori App in SAP Build Apps Workzone, standard edition via Private Link incl. destinations
Exercise 2 (extend to usage with Microsoft Azure): ~20 min
Additional Fiori app based on exercise 1 with additional functionality
Deploy Azure Function that fetches tracking information from delivery services (like UPS https://developer.ups.com/catalog?loc=en_US or DHL/https://developer.dhl.com/ ) 
Wire information up with the sales order app
Summary and Outro: ~ 20 min 

