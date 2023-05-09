
locals {
  workspaceConfig = flatten([for workspace in fileset(path.module, var.workspace-yaml-filepath) : yamldecode(file(workspace))])
  workspaces      = { for workspace in local.workspaceConfig : workspace.workspace_name => workspace }
  #filter workspaces to only those that need a new github repo created
  workspaceRepos = { for workspace in local.workspaceConfig : workspace.workspace_name => workspace if workspace.create_repo }
  #filter workspace to only those with variables sets
  ws_varSets = { for workspace in local.workspaceConfig : workspace.workspace_name => workspace if workspace.create_variable_set }

  #loop though each workspace, then each varset and flatten
  workspace_varset = flatten([
    for key, value in local.ws_varSets : [
      for varset in value["var_sets"] :
      {
        organization        = value["organization"]
        workspace_name      = value["workspace_name"]
        create_variable_set = value["create_variable_set"]
        var_sets            = varset
      }
    ]
  ])
  #convert to a Map with variabel set name as key
  varsetMap = { for varset in local.workspace_varset : varset.var_sets.variable_set_name => varset }
}

module "terraform-tfe-variable-sets" {
  source = "github.com/hashi-demo-lab/terraform-tfe-variable-sets?ref=v0.3.7"

  for_each = local.varsetMap

  organization             = each.value.organization
  create_variable_set      = try(each.value.create_variable_set, true)
  variables                = try(each.value.var_sets.variables, {})
  variable_set_name        = each.value.var_sets.variable_set_name
  variable_set_description = try(each.value.var_sets.variable_set_description, "")
  tags                     = try(each.value.var_sets.tags, [])
  global                   = try(each.value.var_sets.global, false)
}


module "github" {
  source   = "github.com/hashi-demo-lab/terraform-github-repository-module?ref=v0.2.2"
  for_each = local.workspaceRepos

  github_org                       = each.value.github.github_org
  github_org_owner                 = each.value.github.github_org_owner
  github_repo_name                 = each.value.github.github_repo_name
  github_repo_desc                 = try(each.value.github.github_repo_desc, "")
  github_repo_visibility           = try(each.value.github.github_repo_visibility, "private")
  github_team_name                 = try(each.value.github.github_team_name, "")
  github_template_owner            = try(each.value.github.github_template_owner, "hashicorp-demo-lab")
  github_repo_permission           = try(each.value.github.github_repo_permission, "admin")
  github_template_repo             = try(each.value.github.github_template_repo, "terraform-template")
  github_template_include_branches = try(each.value.github.github_template_include_branches, false)
}

module "workspace" {
  source = "github.com/hashi-demo-lab/terraform-tfe-onboarding-module?ref=v0.2.2"

  depends_on = [
    module.github
  ]

  for_each = local.workspaces

  organization                = each.value.organization
  create_project              = try(each.value.create_project, false)
  project_name                = try(each.value.project_name, "Default Project")
  workspace_name              = each.value.workspace_name
  workspace_description       = try(each.value.workspace_description, "")
  workspace_terraform_version = try(each.value.workspace_terraform_version, "")
  workspace_tags              = try(each.value.workspace_tags, [])
  variables                   = try(each.value.variables, {})
  assessments_enabled         = try(each.value.assessments_enabled, false)

  file_triggers_enabled   = try(each.value.file_triggers_enabled, true)
  workspace_vcs_directory = try(each.value.workspace_vcs_directory, "root_directory")
  workspace_auto_apply    = try(each.value.workspace_auto_apply, false)

  # Remote State Sharing
  remote_state           = try(each.value.remote_state, false)
  remote_state_consumers = try(each.value.remote_state_consumers, [""])

  #VCS block
  vcs_repo = try(each.value.vcs_repo, {})

  #Agents
  workspace_agents = try(each.value.workspace_agents, false)
  execution_mode   = try(each.value.execution_mode, "remote")
  agent_pool_name  = try(each.value.agent_pool_name, null)

  #RBAC
  workspace_read_access_emails  = try(each.value.workspace_read_access_emails, [])
  workspace_write_access_emails = try(each.value.workspace_write_access_emails, [])
  workspace_plan_access_emails  = try(each.value.workspace_plan_access_emails, [])
}


data "tfe_workspace_ids" "all" {
  depends_on = [
    module.workspace
  ]
  names        = ["*"]
  organization = var.organization
}

locals {
  varset_out = module.terraform-tfe-variable-sets
}


# Associate varset with workspace
resource "tfe_workspace_variable_set" "set" {
  depends_on = [
    module.workspace,
    module.terraform-tfe-variable-sets
  ]
  for_each        = local.varsetMap
  variable_set_id = local.varset_out[each.value.var_sets.variable_set_name].variable_set[0].id
  workspace_id    = lookup(data.tfe_workspace_ids.all.ids, each.value.workspace_name)

} 

