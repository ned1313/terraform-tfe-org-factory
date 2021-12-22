output "organization_name" {
  value = local.organization_name
  description = "Name of organization being managed"
}

output "userid_list" {
    value = { for k,v in tfe_organization_membership.org_members : k => v.user_id }
    description = "List of user IDs created."
}

output "teamid_list" {
    value = { for k,v in tfe_team.teams : k => v.id }
    description = "List of team IDs created"
}
