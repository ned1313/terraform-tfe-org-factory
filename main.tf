# Create an organization depending on var.create_new_organization
resource "tfe_organization" "org" {
  count = var.create_new_organization ? 1 : 0
  name  = var.organization_name
  email = var.organization_email
}

locals {

  # Set the organization name depending on whether its a new org or existing
  organization_name = var.create_new_organization ? tfe_organization.org[0].id : var.organization_name

  # Import org data from json file
  org_data = jsondecode(file("${var.config_file_path}"))

  #Create a list of workspace access entries
  workspace_team_access = flatten([
    for workspace in local.org_data.workspaces : [
      for team in workspace["teams"] : {
        workspace_name = workspace["name"]
        team_name      = team["name"]
        access_level   = team["access_level"]
      }
    ]
  ])

}

# Create workspaces
resource "tfe_workspace" "workspaces" {
  # Create a map of workspaces from the list stored in JSON using the
  # workspace name as the key
  for_each          = { for workspace in local.org_data.workspaces : workspace["name"] => workspace }
  name              = each.key
  description       = each.value["description"]
  terraform_version = each.value["terraform_version"]
  organization      = local.organization_name
  tag_names         = each.value["tag_names"]
}

# Create teams
resource "tfe_team" "teams" {
  # Create a map of teams from the list stored in JSON using the 
  # team name as the key
  for_each     = { for team in local.org_data.teams : team["name"] => team }
  name         = each.key
  organization = local.organization_name
  visibility   = each.value["visibility"]

  organization_access {

    manage_policies         = each.value.organization_access["manage_policies"]
    manage_policy_overrides = each.value.organization_access["manage_policy_overrides"]
    manage_workspaces       = each.value.organization_access["manage_workspaces"]
    manage_vcs_settings     = each.value.organization_access["manage_vcs_settings"]
  }
}


# Configure workspace access for teams
resource "tfe_team_access" "team_access" {
  for_each     = { for access in local.workspace_team_access : "${access.workspace_name}_${access.team_name}" => access }
  access       = each.value["access_level"]
  team_id      = tfe_team.teams[each.value["team_name"]].id
  workspace_id = tfe_workspace.workspaces[each.value["workspace_name"]].id
}

# Add TFC accounts to the organization
resource "tfe_organization_membership" "org_members" {
  for_each     = toset(flatten(local.org_data.teams.*.members))
  organization = local.organization_name
  email        = each.value
}

locals {
  # Create a list of member mappings like this
  # team_name = team_name
  # member_name = member_email
  team_members = flatten([
    for team in local.org_data.teams : [
      for member in team["members"] : {
        team_name   = team["name"]
        member_name = member
      } if length(team["members"]) > 0
    ]
  ])
}

resource "tfe_team_organization_member" "team_members" {
  for_each                   = { for member in local.team_members : "${member.team_name}_${member.member_name}" => member }
  team_id                    = tfe_team.teams[each.value["team_name"]].id
  organization_membership_id = tfe_organization_membership.org_members[each.value["member_name"]].id
}