# Create an organization depending on var.create_new_organization
resource "tfe_organization" "org" {
  count = var.create_new_organization ? 1 : 0
  name  = var.organization_name
  email = var.organization_email
}

locals {
  organization_name = var.create_new_organization ? tfe_organization.org[0].id : var.organization_name
}

# Create workspaces in organization
resource "tfe_workspace" "workspaces" {
  for_each     = var.workspaces
  name         = each.key
  organization = local.organization_name
  tag_names    = each.value["tags"]
}

# Create teams
resource "tfe_team" "teams" {
  for_each     = toset(keys(var.teams))
  name         = each.value
  organization = local.organization_name
  visibility   = "organization"
}

locals {

  org_members = toset(flatten(values(var.teams)))

  team_members = flatten([
    for team, members in var.teams : [
      for member in members : {
        team_name   = team
        member_name = member
      } if length(members) > 0
    ]
  ])
}

# Add members to teams
resource "tfe_organization_membership" "org_members" {
  for_each = local.org_members
  organization = local.organization_name
  email = each.value
}

resource "tfe_team_organization_member" "team_members" {
  count = local.team_members
  team_id = tfe_team.teams[local.team_members[count.index].team_name].id
  organization_membership_id = tfe_organization_membership.org_members[local.team_members[count.index].member_name].id
}

# Create lists for each access level
locals {
  workspace_read_access = flatten([
    for workspace, settings in var.workspaces : [
      for entry in settings["read_access"] : {
        workspace_name = workspace
        team_name      = entry
      } if length(settings["read_access"]) > 0
    ]
  ])

  workspace_plan_access = flatten([
    for workspace, settings in var.workspaces : [
      for entry in settings["plan_access"] : {
        workspace_name = workspace
        team_name      = entry
      } if length(settings["plan_access"]) > 0
    ]
  ])

  workspace_write_access = flatten([
    for workspace, settings in var.workspaces : [
      for entry in settings["write_access"] : {
        workspace_name = workspace
        team_name      = entry
      } if length(settings["write_access"]) > 0
    ]
  ])

  workspace_admin_access = flatten([
    for workspace, settings in var.workspaces : [
      for entry in settings["admin_access"] : {
        workspace_name = workspace
        team_name      = entry
      } if length(settings["admin_access"]) > 0
    ]
  ])

}

# Configure workspace access for teams
resource "tfe_team_access" "read_access" {
  count        = length(local.workspace_read_access)
  access       = "read"
  team_id      = tfe_team.teams[local.workspace_read_access[count.index].team_name].id
  workspace_id = tfe_workspace.workspaces[local.workspace_read_access[count.index].workspace_name].id
}

resource "tfe_team_access" "plan_access" {
  count        = length(local.workspace_plan_access)
  access       = "plan"
  team_id      = tfe_team.teams[local.workspace_plan_access[count.index].team_name].id
  workspace_id = tfe_workspace.workspaces[local.workspace_plan_access[count.index].workspace_name].id
}

resource "tfe_team_access" "write_access" {
  count        = length(local.workspace_write_access)
  access       = "write"
  team_id      = tfe_team.teams[local.workspace_write_access[count.index].team_name].id
  workspace_id = tfe_workspace.workspaces[local.workspace_write_access[count.index].workspace_name].id
}

resource "tfe_team_access" "admin_access" {
  count        = length(local.workspace_admin_access)
  access       = "admin"
  team_id      = tfe_team.teams[local.workspace_admin_access[count.index].team_name].id
  workspace_id = tfe_workspace.workspaces[local.workspace_admin_access[count.index].workspace_name].id
}