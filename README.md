# Unity Catalog Terraform deployment

This repository contains Terraform code used to Deploy Untiy Catalog resources, together with the CI/CD pipeline that automate resources provisioning in addition to validating the pull request changes before applying them & using approvals before deploying changes to production system.  Please note that the existing Terraform code was deployed in Microsoft Azure Cloud.
In this repo, among others you will find the Terraform resources used to create Unity Catalog metastore, Databricks service principals, assign principals to workspaces, Create Unity Catalog resources like catalogs and schemas and grant access to principals to these UC resources.
## Workflow

The general workflow contains the following steps:

* Changes to the code in this directory or in the module are made in a separate Git branch & when changes are ready, a pull request is opened
* Upon opening of the pull request, the build pipeline is triggered, and following operations are performed:
  * Initializes Terraform using a remote backend to store a [Terraform state](https://www.terraform.io/language/state).
  * Perform check of the Terraform code for formatting consistency.
  * Performs check of the Terraform code using [terraform validate](https://www.terraform.io/cli/commands/validate).
  * Executes `terraform plan` to get the list changes that will be made during deployment.

* If the build pipeline is executed without errors, the code should be reviewed by reviewer, and merged into the `main` branch.
* When code is merged into the `main` branch, the release pipeline is triggered, and after a manual approval, changes are applied to the deployment using the `terraform apply` command.

### Structure of terraform templates
The terraform unity catalog repo is structered as follows:
* devops_pipelines folder: it contains the yaml file for each build pipeline. And one release pipeline that gets triggered on tag creation in the repo
* modules: it contains the different re-usable modules, including:
  * unity-catalog-metastore: it defines the necessary resources to create the Unity Catalog metastore.
  * metastore-workspace-assignment: it assigns a Unity Catalog metastore to a specific workspace
  * service-principals : it create the Databricks service principals that are linked to existing AAD service principals in Databricks account
  * service-principals-workspace-assignment : It assigns the service principals to a given Databricks workspace
  * use-case-1 : it defines the Unity Catalog resources for a specific use cases including catalogs, schemas, external locations..
* environments: it contains one folder per environment. Within each folder, we call the different re-usable modules and we define the values for the modules variables per environment and per use case if needed. We also have one additional folder: `shared` in which we create the Unity Catalog metastore, and the Databricks service principals using the account API


### Configuring Terraform code

You can customize this project by modifying the `terraform.tfvars` file that defines following variables necessary for each module. For example:

* `workspace_id`

## Configuring Azure DevOps pipelines

As described above, we need two pipelines:

* The build pipeline is responsible for validation of changes in pull requests.
* The release pipeline is responsible for deploying the changes.

We also need to define auxiliary objects in the Azure DevOps project that will be used by the both pipelines:

* Azure Data Lake Storage (ADLS) account and container that will be used to store Terraform state.
* The remote state is using the storage account in terraform-state-rg resource group in the subscription sub-terraformstate
* [Service connection for Azure Resource Manager](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml#azure-resource-manager-service-connection) that will be used to access data of Terraform state in Azure Data Lake Storage (ADLS) container via [azure remote backend](https://www.terraform.io/language/settings/backends/azurerm).  The configured identity needs to have write access to the configured ADLS container.
* [Azure DevOps variable group](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups) will store all variables used by the both pipelines.

### Configuring the variable group

We need to configure a variable group that should contain the following variables:

* `BACKEND_RG_NAME` - name of resource group containing storage account.
* `BACKEND_SA_NAME` - name of the storage account.
* `BACKEND_CONTAINER_NAME` - name of the container inside the storage account.
* `BACKEND_KEY` - name of the blob (file) object that will be used to store the Terraform state of our deployment.
* `SERVICE_CONNECTION_NAME` - name of the Azure DevOps service connection for Azure Resource Manager that was defined earlier.


### Configuring the build pipeline

Create a build pipeline by navigating to the "Pipelines" section of your Azure DevOps project, and click "New pipeline" that will walk you through configuration:

* Select Git repository with the code
* Select the "Existing Azure Pipelines YAML file" option, and select `/azure-pipeline-<env>.yml` from the dropdown
* Select "Save" from the dropdown in the "Run" button
* In Azure Devops repo, create new [branch policy](https://learn.microsoft.com/en-us/azure/devops/repos/git/branch-policies) in the `main` branch in order to prevent direct push to the main branch and to trigger the build pipeline when the selected paths get modified

This will create a new build pipeline that will be triggered on the pull request to the `main` branch & validate proposed changes.



### Configuring the release pipeline

Create a release pipeline by navigating to the "Releases" in the "Pipelines" section of your Azure DevOps project, and select "New release pipeline" from the "New" dropdown.  We won't use any existing template, so close the dialog on the right.

We need to define two things:

1. Artifact that will be used to trigger the release pipeline.
1. Stage that will be executed as part of the release.

Don't forget to press "Save" after configuration is done

#### Configuring release artifact

Release artifact is configured as following:

* Click on the "Add an artifact" button, then select your Git implementation (GitHub, Azure DevOps, ...), and select a repository with the code.
* Select the default branch - set it to `main`
* Set the "Default version" field to value "Latest from the default branch"
* Set the "Source alias" field to something easy to remember - we'll use that value in the stages.  For example, `db-unity-catalog-terraform`
* Click on the "⚡" icon to configure the continuous deployment (by default, release is triggered manually). Toggle the "Enabled" switch, add the branch filter and also select the `main` branch

#### Configuring the stage of the release pipeline

Configure stage by pressing "Add a stage":

* Select "Empty Job" in the dialog
* In the Stage dialog enter some meaningful name for it
* In the "Variables" tab, link the variable group that was created previously
* Switch to Tasks tab to configure agent - select "Azure pipelines" in the "Agent pool", and in the "Agent Specification" select "ubuntu-latest"
* Use "+" on the "Agent job" to add tasks. We need to define 4 tasks:

1. Task that will be used to install Terraform. Search for "Command line" task and add it.  Give it name like "Install Terraform" and enter following code into the "Script" field:

```sh
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```



2. Task that will extract necessary data for authentication against the state backend. Search for "Azure CLI" task and add it.  Give it name like "Extract information from Azure CLI", and set parameters as following:

* Select your service connection in "Azure Resource Manager connection" dropdown
* In "Script Type" select "Shell"
* In "Script Location" select "Inline script"
* Make sure that "Access service principal details in script" is checked
* Put following into "Inline Script" text block:

  ```sh
  subscription_id=$(az account list --query "[?isDefault].id"|jq -r '.[0]')
  echo "##vso[task.setvariable variable=ARM_CLIENT_ID]${servicePrincipalId}"
  echo "##vso[task.setvariable variable=ARM_CLIENT_SECRET;issecret=true]${servicePrincipalKey}"
  echo "##vso[task.setvariable variable=ARM_TENANT_ID]${tenantId}"
  echo "##vso[task.setvariable variable=ARM_SUBSCRIPTION_ID]${subscription_id}"
  ```

3. Task to perform initialization of Terraform using the state in the remote backend. Search for Command line" task, add it, and configure following parameters:

* Put `$(System.DefaultWorkingDirectory)/db-unity-catalog-terraform/prod` into the "Working Directory" field under "Advanced" block.
* Add environment variable with name `ARM_CLIENT_SECRET` and value `$(ARM_CLIENT_SECRET)`
* Put following code into "Script" field:

  ```sh
  terraform init -input=false -no-color \
    -backend-config="resource_group_name=$BACKEND_RG_NAME" \
    -backend-config="storage_account_name=$BACKEND_SA_NAME" \
    -backend-config="container_name=$BACKEND_CONTAINER_NAME" \
    -backend-config="key=$BACKEND_KEY"
  ```

4. Task to apply changes. Search for Command line" task, add it, and configure following parameters:

* Put `$(System.DefaultWorkingDirectory)/db-unity-catalog-terraform/prod` into the "Working Directory" field under "Advanced" block.
* Add one environment variable: with name `ARM_CLIENT_SECRET` and value `$(ARM_CLIENT_SECRET)`.
* Put following code into "Script" field:

  ```sh
  terraform apply -input=false -no-color -auto-approve
  ```

The final step of the configuration for release pipeline is configuration of approvals.  Click on the "⚡", select the "After release" trigger, and then toggle the "Pre-deployment approvals" button. Put names of the approvers into the "Approvers" box - they will get notification when release is triggered, and they will need to approve deployment of the changes.

#### Trigger release pipeline on every tag creation
* The yaml file azure-release-pipeline can also be used to create a release pipeline that gets triggered automatically at every tag creation. It deploys Unity catalog resources in all environments