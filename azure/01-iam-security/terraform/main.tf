# ============================================================================
# Azure IAM Security Lab - Phase 1: Custom RBAC Roles
# ============================================================================

# Data source to get current Azure subscription
data "azurerm_subscription" "current" {}

# Data source to get current client (logged in user/service principal)
data "azurerm_client_config" "current" {}

# Data source for existing resource group
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# ============================================================================
# Custom RBAC Role: Security Auditor (Read-Only)
# Azure equivalent of AWS custom IAM policy
# ============================================================================

resource "azurerm_role_definition" "security_auditor" {
  name        = "${var.project_name}-security-auditor"
  scope       = data.azurerm_subscription.current.id
  description = "Read-only access to security services for auditing and compliance reviews"

  permissions {
    # Read permissions for security and monitoring
    actions = [
      # Read resources
      "*/read",

      # Read Activity Logs (corrected action)
      "Microsoft.Insights/eventtypes/values/read",
      "Microsoft.Insights/eventtypes/digestevents/read",

      # Read Log Analytics
      "Microsoft.OperationalInsights/workspaces/query/*/read",

      # Read Microsoft Defender for Cloud
      "Microsoft.Security/*/read",

      # List all resources
      "Microsoft.Resources/subscriptions/resources/read",
      "Microsoft.Resources/subscriptions/resourceGroups/read"
    ]

    # No data plane actions
    data_actions = []

    # Deny write operations on critical security resources
    not_actions = [
      # Prevent role modifications
      "Microsoft.Authorization/roleAssignments/write",
      "Microsoft.Authorization/roleAssignments/delete",
      "Microsoft.Authorization/roleDefinitions/write",
      "Microsoft.Authorization/roleDefinitions/delete",

      # Prevent security configuration changes
      "Microsoft.Security/*/write",
      "Microsoft.Security/*/delete",

      # Prevent Activity Log modifications
      "Microsoft.Insights/diagnosticSettings/write",
      "Microsoft.Insights/diagnosticSettings/delete"
    ]

    not_data_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id
  ]
}

# ============================================================================
# Azure AD Security Group for Security Auditors
# Equivalent to IAM role in AWS
# ============================================================================

resource "azuread_group" "security_auditors" {
  display_name     = "${var.project_name}-security-auditors"
  description      = "Security auditors with read-only access to security services"
  security_enabled = true

  # Can't assign members via Terraform due to permissions
  # Will document manual assignment process
}

# ============================================================================
# Role Assignment: Assign custom role to the group at subscription level
# ============================================================================

resource "azurerm_role_assignment" "security_auditor_assignment" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = azurerm_role_definition.security_auditor.role_definition_resource_id
  principal_id       = azuread_group.security_auditors.object_id
}

# ============================================================================
# Also assign built-in Security Reader role for comprehensive access
# ============================================================================

resource "azurerm_role_assignment" "security_reader_assignment" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Security Reader"
  principal_id         = azuread_group.security_auditors.object_id
}
