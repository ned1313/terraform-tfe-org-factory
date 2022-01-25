output "organization_name" {
  value       = local.organization_name
  description = "Name of organization being managed."
}

output "userid_list" {
  value       = { for k, v in tfe_organization_membership.org_members : k => v.user_id }
  description = "Map of usernames to users IDs created."
}

output "teamid_list" {
  value       = { for k, v in tfe_team.teams : k => v.id }
  description = "Map of team names to team IDs created."
}
