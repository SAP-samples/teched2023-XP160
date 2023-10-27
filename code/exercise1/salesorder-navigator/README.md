# Getting Started

Welcome to your new project.

It contains these folders and files, following our recommended project layout:

File or Folder | Purpose
---------|----------
`app/` | content for UI frontends goes here
`db/` | your domain models and data go here
`srv/` | your service models and code go here
`package.json` | project metadata and configuration
`readme.md` | this getting started guide


## Next Steps

- Open a new terminal and run `cds watch` 
- (in VS Code simply choose _**Terminal** > Run Task > cds watch_)
- Start adding content, for example, a [db/schema.cds](db/schema.cds).

### Optional

For local testing of the Shipping API from SAP BAS bind to your destination service and execute hybrid profile

- `cf create-service-key salesorder-navigator-destination salesorder-navigator-destination-key`
- `cds bind salesorder-navigator-srv -2 salesorder-navigator-destination`
- `cds watch --profile hybrid`

This approach is not applicable to destinations pointing to a SAP Private Link. For these you need use `cf ssh`. Learn more about that [here](https://blogs.sap.com/2021/10/05/btp-private-linky-swear-with-azure-how-do-i-debug-and-test-with-live-data/).

## Learn More

Learn more at https://cap.cloud.sap/docs/get-started/.
