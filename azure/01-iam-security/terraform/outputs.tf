output "subscription_id" {
  description = "Azure Subscription ID"
  value       = data.azurerm_subscription.current.subscription_id
}

output "tenant_id" {
  description = "Azure AD Tenant ID"
  value       = data.azurerm_client_config.current.tenant_id
}

output "security_auditor_role_id" {
  description = "ID of the custom security auditor role"
  value       = azurerm_role_definition.security_auditor.role_definition_id
}

output "security_auditor_role_name" {
  description = "Name of the custom security auditor role"
  value       = azurerm_role_definition.security_auditor.name
}

output "security_auditors_group_id" {
  description = "Object ID of the security auditors Azure AD group"
  value       = azuread_group.security_auditors.object_id
}

output "security_auditors_group_name" {
  description = "Name of the security auditors group"
  value       = azuread_group.security_auditors.display_name
}
