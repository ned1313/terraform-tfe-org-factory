organization_name = "taco-workspaces"

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
  developers = ["james@abc.com", "alice@abc.com", "sammy@abc.com"]
  opsadmins  = ["gerome@abc.com", "charice@abc.com", "duncan@abc.com"]
  auditors   = ["jake@abc.com", "alice@abc.com", "gerome@abc.com"]
}