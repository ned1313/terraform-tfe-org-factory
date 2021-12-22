# tfe-org-factory
Terraform module which creates Terraform Cloud organizations, workspaces, and teams

## Usage

```hcl
module "tfe" {
    source = "ned1313/org-factory/tfe"
    
    organization_name = "name-of-organization-to-manage"
    create_new = true
    workspaces = {
        network-dev = {
            read_access = ["developers"]
            plan_access = []
            write_access = ["networking"]
            admin_access = []
            tags = ["development","networking"]
        }
    }
}
```

## Terraform Cloud Plan

The organization created or used by the module must be enrolled in the **Teams & Governance** plan for teams to be created and permissions assigned to the workspaces. If you are creating a new organization, you can apply the module once to create the org, then change the billing plan. On the second run, the teams and permissions will be created.