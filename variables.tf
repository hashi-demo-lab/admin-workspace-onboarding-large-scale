# Organization level variables

variable "workspace-yaml-filepath" {
  description = "TFC Organization to build under"
  type        = string
  default = "dummy.yaml"

  validation {
    condition     = length(var.workspace-yaml-filepath) > 6 && substr(var.workspace-yaml-filepath, 0, 6) == "config"
    error_message = "please supply the full path to a single yaml file config Example: config/someworkspace.yaml"
  }
}


variable "organization" {
  description = "TFC Organization to build under"
  type        = string
  default = "hashi-demos-apj"
}

# Workspace level variables
variable "workspace_name" {
  description = "Name of the workspace to create"
  type        = string
  default = ""
}

variable "workspace_description" {
  description = "Description of workspace"
  type        = string
  default     = ""
}

variable "workspace_terraform_version" {
  description = "Version of Terraform to run"
  type        = string
  default     = "latest"
}

variable "workspace_tags" {
  description = "Tags to apply to workspace"
  type        = list(string)
  default     = []
}


## VCS variables (existing VCS connection)
variable "vcs_repo" {
  description = "(Optional) - Map of objects that will be used when attaching a VCS Repo to the Workspace. "
  default     = {}
  type        = map(string)
}

variable "workspace_vcs_directory" {
  description = "Working directory to use in repo"
  type        = string
  default     = "root_directory"
}

variable "branch" {
  description = "(Optional) - VCS Repo branch"
  default     = null
  type        = string
}

variable "tags_regex" {
  description = "(Optional) -  regex git tags"
  default     = null
  type        = string
}

variable "file_triggers_enabled" {
  description = "(Optional) -  file_triggers_enabled"
  default     = true
  type        = bool
}

# Variables
variable "variables" {
  description = "Map of all variables for workspace"
  type        = map(any)
  default     = {}
}

variable "create_project" {
  description = "(Optional) Boolean that allows for the creation of a Project in Terraform Cloud that the workspace will use. This feature is in beta and currently doesn't have a datasource"
  type        = bool
  default     = false
}

variable "project_name" {
  description = "(Optional) Name of the Project that is created in Terraform Cloud if var.create_project is set to true. Note this is currently in beta"
  type        = string
  default     = ""
}

variable "assessments_enabled" {
  description = "(Optional) Boolean that enables heath assessments on the workspace"
  type        = bool
  default     = false
}

# # RBAC
# ## Workspace owner (exising org user)
# variable "workspace_owner_email" {
#   description = "Email for the owner of the account"
#   type        = string
# }

## Additional read users (existing org user)
variable "workspace_read_access_emails" {
  description = "Emails for the read users"
  type        = list(string)
  default     = []
}

## Additional write users (existing org user)
variable "workspace_write_access_emails" {
  description = "Emails for the write users"
  type        = list(string)
  default     = []
}

## Additional plan users (existing org user)
variable "workspace_plan_access_emails" {
  description = "Emails for the plan users"
  type        = list(string)
  default     = []
}




## Kalen Additions

variable "agent_pool_name" {
  type        = string
  description = "(Optional) Name of the agent pool that will be created or used"
  default     = null
}

variable "workspace_agents" {
  type        = bool
  description = "(Optional) Conditional that allows for the use of existing or new agents within a given workspace"
  default     = false
}

variable "workspace_auto_apply" {
  type        = string
  description = "(Optional)  Setting if the workspace should automatically apply changes when a plan succeeds."
  default     = false
}

variable "execution_mode" {
  type        = string
  description = "(Optional) Defines the execution mode of the Workspace. Defaults to remote"
  default     = "remote"
}

variable "remote_state" {
  type        = bool
  description = "(Optional) Boolean that enables the sharing of remote state between this workspace and other workspaces within the environment"
  default     = false
}

variable "remote_state_consumers" {
  type        = set(string)
  description = "(Optional) Set of remote IDs of the workspaces that will consume the state of this workspace"
  default     = [""]
}

# variable "rbac" {
#   type = bool
#   description = "(Optional) Conditional that allows for RBAC policy to be created for the new workspaces"
#   default = true
# }

# GitHub Variables

variable "github_org" {
  description = "GitHub organization name"
  default     = "hashicorp-demo-lab"
}

variable "github_org_owner" {
  description = "GitHub organization owner"
  default     = "hashicorp-demo-lab"
}

variable "github_repo_name" {
  description = "The name of the new repository"
  type        = string
  default     = ""
}

variable "github_repo_desc" {
  description = "The description of the new repository"
  type        = string
  default     = "this repo was created by Terraform"
}


variable "github_repo_visibility" {
  description = "github repo visibility"
  type        = string
  default     = "public"
}

variable "github_team_name" {
  description = "github team name"
  default     = "demo-team"
}

variable "github_template_owner" {
  description = "The GitHub organization or user the template repository is owned by"
  default     = "hashicorp-demo-lab"
}

variable "github_repo_permission" {
  description = "Repository permission"
  default     = "admin"
}

variable "github_template_repo" {
  description = "The name of the repository template"
  default     = "terraform-template"
}

variable "github_template_include_branches" {
  description = "include all branches from github template"
  type        = bool
  default     = false
}
