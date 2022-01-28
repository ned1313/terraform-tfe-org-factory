# tfe-org-factory
Terraform module which creates Terraform Cloud organizations, workspaces, and teams

## Usage

```hcl
module "tfe" {
    source = "ned1313/org-factory/tfe"
    
    organization_name = "name-of-organization-to-manage"
    create_new = true
    config_file_path = "path_to_config_file.json"
}
```

The JSON file holding the configuration should follow the format outlined here or in the `example_config.json` file.

```json
{
    "workspaces": [
        {
            "name": "workspace_name",
            "description": "workspace description",
            "teams": [
                {
                    "name": "team_name",
                    "access_level": "access_level"
                }
            ],
            "terraform_version": "1.1.0",
            "tag_names": [
                "tag1"
            ]
        }
    ],
    "teams": [
        {
            "name": "team_name",
            "visibility": "visibility_level",
            "organization_access": {
                "manage_policies": true,
                "manage_policy_overrides": true,
                "manage_workspaces": false,
                "manage_vcs_settings": false
            },
            "members": [
                "user_email_address"
            ]
        }
    ]
}
```

Note: Only the name is required for the teams and workspaces. All other fields are optional. The Terraform version for workspaces will be set to "~> 1.0" if no value is provided.

## Terraform Cloud Plan

The organization created or used by the module must be enrolled in the **Teams & Governance** plan for teams to be created and permissions assigned to the workspaces. If you are creating a new organization, you can apply the module once to create the org, then change the billing plan. On the second run, the teams and permissions will be created.