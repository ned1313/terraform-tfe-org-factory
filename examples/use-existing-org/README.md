# Using TFE Org Factory with an Existing Org

This example assumes you are using an existing organization in Terraform Cloud and you want to create workspaces, teams, users, and permissions. The `basic_config.json` file has pre-populated workspaces, teams, and users. You will need supply the value for the `organization_name` variable and credentials for the `tfe` provider. We recommend using the `TFE_TOKEN` environment variable with a user token that has proper privileges to manage workspaces, teams, users, and permissions.

You can run this example as is by doing the following:

```bash
export TFE_TOKEN=<your-token-value>
terraform init
terraform apply -var organization_name="<your-org-name>"
```