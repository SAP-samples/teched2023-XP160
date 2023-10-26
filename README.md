[![REUSE status](https://api.reuse.software/badge/github.com/SAP-samples/teched2023-XP160)](https://api.reuse.software/info/github.com/SAP-samples/teched2023-XP160)

# XP160 - Using Terraform for Cross-Cloud Setup of SAP BTP and Microsoft Azure

## Description

This repository contains the material for the [SAP TechEd 2023 session XP160 - Using Terraform for Cross-Cloud Setup of SAP BTP and Microsoft Azure](https://go2.events.sap.com/TechEd2023/agb/go/agendabuilder.sessions/?l=326&sid=116844&schid=520496&locale=en_US).

## Overview

This session introduces attendees to Terraform as the de-facto standard for infrastructure as code. You will get hands-on experience with deploying and provisioning your apps cross-cloud running on SAP Business Technology Platform (SAP BTP) that integrate with Microsoft Azure services using the SAP Private Link service.

![Architecture Overview](/exercises/get_started/use-case.png)

Leverage the new Terraform provider for SAP BTP to automate the setup of your SAP BTP accounts along with Terraform for Azure.

## Requirements

The requirements to follow the exercises in this repository are:

- Terraform CLI installed on your computer (already the case for the machines available at TechEd 2023)
- You need to have a GitHub user. If you don't have one so far, please [sign-up on GitHub](https://github.com/signup) before going through the exercises

> **Note** - The setup for this exercise (e.g. setting up the individual Subaccounts, setting the entitlements, deploying Cloud Foundry services, ...) were also all done leveraging the Terraform provider for SAP BTP. You can find the scripts [here](code/admin/). These scripts will not be part of the exercises, but feel free to learn from the scripts provided [there](code/admin/).

## Exercises

Prior the exercises you will be given an [introduction to Terraform and the goal of the exercises of the session XP160](exercises/get_started/XP160%20-%20Automating%20SAP%20BTP%20Accounts%20with%20Terraform%20Provider.pdf).

These are the exercises you will go through during the hands-on session XP160:

- [Exercise 0 - Prepare your development environment](exercises/exercise0/)
  - Create your GitHub Codespace
  - Get your BTP user credentials
  - Get your BTP subaccount ID

- [Exercise 1 - Setup your SAP BTP Subaccount](exercises/exercise1/)
  - Create privatelink service instance + service key (CF)
  - Create destination service + destination
  - Create SAP Build Workzone, standard edition subscription
  - Deploy UI5 app using managed approuter (requires Workzone subscription)

- [Exercise 2 - Azure developer setup](exercises/exercise2/)
  - Provision Azure resources
  - Deploy Azure Functions app

- [Exercise 3 - Connect Azure Function and UI5 app](exercises/exercise3/)
  - Update the Destination

- [Exercise 4 - Cleanup](exercises/exercise4/)
  - Destroy the resources created in the previous exercises

## Contributing

Please read the [CONTRIBUTING.md](./CONTRIBUTING.md) to understand the contribution guidelines.

## Code of Conduct

Please read the [SAP Open Source Code of Conduct](https://github.com/SAP-samples/.github/blob/main/CODE_OF_CONDUCT.md).

## How to obtain support

Support for the content in this repository is available during the actual time of the hands-on session for which this content has been designed. Otherwise, you may request support via the [Issues](../../issues) tab.

## License

Copyright (c) 2023 SAP SE or an SAP affiliate company. All rights reserved. This project is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSES/Apache-2.0.txt) file.
