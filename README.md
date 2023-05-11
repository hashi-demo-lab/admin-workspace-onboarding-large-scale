This GitHub Action Workflow automates the process of onboarding new workspaces in the Terraform Cloud  using the Terraform Cloud API driven workflow.

The action performs the following steps:
- Parses a YAML configuration file that contains the list of workspaces to be onboarded.
- Validates the YAML configuration files.
- Creates a new administrative workspace with the same configuration and variables as the onboarded workspaces.
- Uploads the Terraform configuration of each workspace to Terraform Cloud.
- Reads the matrix outputs using artifacts until GitHub supports dynamic matrix outputs.
- Runs the Terraform workspace for each onboarded workspace in parallel.

Workflow Configuration

This action is triggered using (workflow_dispatch) or when changes are pushed to the main branch. Ideally this should be changed

The workflow uses the following environment variables:
- TF_CLOUD_ORGANIZATION: The name of the Terraform Cloud organization.
- TF_API_TOKEN: The Terraform Cloud API token.
- TF_DIRECTORY: The Terraform configuration directory.
- PROJECT_ID: The ID of the TFC project for admin workspaces.

The action performs four jobs:
- parse-ws-config: Parses the workspace configuration files and validates them.
- tfe-ws-prereqs: Creates an administrative workspace for each onboarded workspace.
- tfe-cfg: Uploads the Terraform configuration of each onboarded workspace to Terraform Cloud.
- tfe-ws-run: Runs the Terraform workspace for each onboarded workspace in parallel.
