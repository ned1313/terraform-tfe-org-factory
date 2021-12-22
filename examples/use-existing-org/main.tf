#### Locals 

locals {
  organization_name = "existing-workspace"

workspaces = {
  workspace1 = {
    read_access  = ["auditors"]
    plan_access  = []
    write_access = []
    admin_access = ["developers"]
    tags         = ["dev", "applications"]
  }
  workspace2 = {
    read_access  = ["auditors"]
    plan_access  = []
    write_access = []
    admin_access = ["opsadmins"]
    tags         = ["dev", "infrastructure"]
  }
  workspace3 = {
    read_access  = ["auditors"]
    plan_access  = []
    write_access = ["developers"]
    admin_access = []
    tags         = ["prod", "applications"]
  }
}

teams = {
  developers = ["james@example.com", "alice@example.com", "sammy@example.com"]
  opsadmins  = ["gerome@example.com", "charice@example.com", "duncan@example.com"]
  auditors   = ["jake@example.com", "alice@example.com", "gerome@example.com"]
}

}

module "tfe_workspace" {
  source = "../.."

  organization_name = local.organization_name
  workspaces = local.workspaces
  teams = local.teams
}