variable "organization_name" {
  type        = string
  description = "(Required) Name of organization to use for resource management."
}

variable "create_new_organization" {
  type        = bool
  description = "(Optional) Whether to create a new organization or use an existing one. Defaults to false."
  default     = false
}

variable "organization_email" {
  type        = string
  description = "(Required) Email of owner for organization."
}

variable "workspaces" {
  description = "(Required) A map of workspaces to create. See comments for more information."

  /*
  Each workspace includes the following elements:
  * read_access - a list of teams who should have read access on the workspace
  * plan_access - a list of teams who should have plan access on the workspace
  * write_access - a list of teams who should have write access on the workspace
  * admin_access - a list of teams who should have admin access on the workspace
  * tags - a list of tags to apply to the workspace

  Teams referenced by the access entries must be created by this module with the teams variable.
  */

  type = map(object({
    read_access  = list(string)
    plan_access  = list(string)
    write_access = list(string)
    admin_access = list(string)
    tags         = list(string)
  }))

}

variable "teams" {
  type        = map(list(string))
  description = "(Required) A map of teams to create. The value is a list of usernames to associate with the Team."
}