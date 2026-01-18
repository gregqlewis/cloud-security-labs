# Lab 00: Azure Account Baseline Security

Initial security configuration establishing foundational controls for all subsequent Azure labs. This baseline implements Azure security best practices before deploying any workloads.

## Overview

**Status:** ✅ Complete  
**Cost:** $0/month (baseline services)  
**Completion Date:** January 2026  
**Subscription:** Azure for Students (Free Account)

## Objectives

- Secure Azure account with MFA
- Establish service principal for automation
- Enable comprehensive audit logging
- Configure proactive cost monitoring
- Set up Azure CLI for automation

## Implementation Summary

### 1. Account Security & MFA

**Actions Taken:**
- ✅ Enabled MFA on Azure account
- ✅ Configured authenticator app for second factor
- ✅ Verified account is sole owner of subscription

**Rationale:**
Azure account credentials provide access to all resources and billing. MFA adds critical second factor protection against credential compromise.

**Security Notes:**
- No root account concept in Azure (Azure AD-based)
- Account used for initial setup, service principal for automation
- MFA enforced at Azure AD level

**Compliance Mapping:**
- Microsoft Cloud Security Benchmark IM-2
- ISO27001 A.9.2.3 (Management of privileged access)

### 2. Resource Organization

**Actions Taken:**
- ✅ Created resource group: `rg-cloudsec-labs`
- ✅ Set location: East US (aligns with federal market)
- ✅ Established naming convention: `rg-[purpose]`

**Resource Group Details:**
```bash
# Resource Group: rg-cloudsec-labs
# Location: East US
# Purpose: Container for all lab resources
# Tags: (will implement in future labs)
```

**Why Resource Groups Matter:**
- Logical container for related resources
- Apply RBAC at group level
- Manage lifecycle together (deploy/delete as unit)
- Cost tracking and billing organization

**Compliance Mapping:**
- ID.AM-1 (Physical devices and systems inventoried)
- Resource organization best practice

### 3. Activity Log & Audit Trail

**Actions Taken:**
- ✅ Created Log Analytics workspace: `law-cloudsec-logs`
- ✅ Configured diagnostic settings: `greg-cloudsec-logs`
- ✅ Enabled log categories: Administrative, Security, Policy
- ✅ Retention: 90 days (Log Analytics default)

**Diagnostic Setting Configuration:**
```
Name: greg-cloudsec-logs
Log Categories:
  - Administrative (all resource operations)
  - Security (security events)
  - Policy (Azure Policy evaluations)
Destination: law-cloudsec-logs (Log Analytics)
Retention: 90 days
```

**What's Being Logged:**
- All resource create/update/delete operations
- RBAC role assignments and changes
- Azure AD sign-ins (if Azure AD Premium)
- Security-related operations
- Policy compliance evaluations

**Cost:** $0-2/month (first 5GB free, Activity Logs typically <100MB/month)

**Why This Matters:**
Activity Logs provide Azure's equivalent of AWS CloudTrail:
- Complete audit trail of subscription activity
- Security incident investigation
- Compliance auditing (ISO27001, NIST)
- Purple team attack/defense documentation

**Compliance Mapping:**
- Microsoft Cloud Security Benchmark LT-1, LT-3
- ISO27001 A.12.4.1 (Event logging)
- NIST CSF DE.AE-3 (Event data aggregated)

### 4. Service Principal for Terraform

**Actions Taken:**
- ✅ Created service principal: `sp-terraform-cloudsec`
- ✅ Assigned Contributor role at subscription scope
- ✅ Documented credentials securely (not in git)
- ✅ Tested authentication

**Service Principal Details:**
```bash
# Display Name: sp-terraform-cloudsec
# Role: Contributor (subscription level)
# Purpose: Terraform automation
# Credentials: Stored in ~/.azure/terraform-credentials.sh (chmod 600)
```

**Why Service Principal:**
- Azure equivalent of AWS access keys
- Enables programmatic access for Terraform
- Separate identity from user account
- Can be assigned specific permissions (least privilege later)

**Security Notes:**
- Credentials stored outside git repository
- Will implement certificate-based auth in future
- Service principal has no interactive login
- Can be rotated without affecting user account

**Credentials Storage:**
```bash
# File: ~/.azure/terraform-credentials.sh (NOT in git)
export ARM_CLIENT_ID="[appId]"
export ARM_CLIENT_SECRET="[password]"
export ARM_TENANT_ID="[tenant]"
export ARM_SUBSCRIPTION_ID="[subscription]"
```

**Compliance Mapping:**
- Microsoft Cloud Security Benchmark IM-3
- Secure credential management
- Automation identity best practices

### 5. Cost Management & Budgets

**Actions Taken:**
- ✅ Set up budget in Azure Portal: $160
- ✅ Configured alert thresholds: 50%, 75%, 90%
- ✅ Added email notifications
- ✅ Enabled cost analysis access

**Budget Configuration:**
```
Budget Name: budget-cloudsec-labs
Amount: $160 USD (80% of $200 credit)
Period: Monthly
Scope: Subscription
Alerts:
  - 50% threshold ($80) → Email alert
  - 75% threshold ($120) → Email alert  
  - 90% threshold ($144) → Email alert
```

**Cost Management Strategy:**
- $200 credit valid for 30 days (free account)
- Set budget at $160 (20% buffer)
- Monthly Cost Analysis reviews
- Resource tagging for cost attribution
- Automated VM shutdown for non-production hours

**Free Services Available:**
- Azure AD Free (basic identity)
- Activity Logs (first 5GB free)
- RBAC (no additional cost)
- Managed Identities (free)
- Limited free tier after credit expires

**Compliance Mapping:**
- Financial controls for lab management
- Demonstrates cost optimization skills

### 6. Azure CLI Configuration

**Actions Taken:**
- ✅ Installed Azure CLI on macOS
- ✅ Authenticated with `az login`
- ✅ Set default subscription
- ✅ Tested CLI commands

**CLI Configuration:**
```bash
# Subscription: Azure for Students (or Azure Free Account)
# Default Location: eastus
# Authentication: Interactive browser login
# Service Principal: Available for Terraform

# Test commands executed:
az account show
az group list
az monitor log-analytics workspace list
az ad sp list --display-name "sp-terraform-cloudsec"
```

**Usage Pattern:**
```bash
# Set default subscription (if multiple)
az account set --subscription "Azure subscription 1"

# Verify current subscription
az account show --output table

# Use service principal for Terraform
export ARM_CLIENT_ID="..."
export ARM_CLIENT_SECRET="..."
terraform apply
```

**Security Notes:**
- Interactive login uses browser-based OAuth
- Credentials cached securely by Azure CLI
- Separate service principal for automation
- Regular credential rotation planned

## Security Baseline Checklist

- ✅ Account MFA enabled
- ✅ Resource group created (rg-cloudsec-labs)
- ✅ Activity Logs configured (all categories)
- ✅ Log Analytics workspace deployed
- ✅ Diagnostic settings enabled
- ✅ Service principal created (Terraform)
- ✅ Budget and cost alerts configured
- ✅ Azure CLI installed and configured
- ✅ Service principal credentials secured
- 📋 Azure AD Conditional Access (Lab 01)
- 📋 Microsoft Defender for Cloud (Lab 02)
- 📋 Azure Policy (future labs)
- 📋 Resource tagging strategy (future labs)

## What Was NOT Configured (And Why)

**Azure AD Premium P1/P2:**
- Cost: $6-9/user/month
- Decision: Start with free tier, document premium features conceptually
- Future: Consider 1-month trial for PIM/Conditional Access hands-on

**Microsoft Defender for Cloud:**
- Cost: Various tiers, some free features available
- Decision: Will enable in Lab 02 (Security Monitoring)
- Free tier provides basic recommendations

**Azure Policy:**
- Cost: Free, but not required for baseline
- Decision: Will implement specific policies in relevant labs
- Future: Compliance policies for ISO27001 alignment

**Network Watcher:**
- Cost: Minimal charges for flow logs
- Decision: Will enable in Lab 03 (Network Security)
- Not required for identity-focused initial labs

## Architecture Diagram
```
┌─────────────────────────────────────────────────────────┐
│              Azure Subscription Security                │
│                                                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌──────────────────────────────────────┐               │
│  │       Azure AD User Account          │               │
│  │  ✓ MFA Enabled                       │               │
│  │  ✓ Owner role on subscription        │               │
│  └──────────────────────────────────────┘               │
│                                                         │
│  ┌──────────────────────────────────────┐               │
│  │  Service Principal (Terraform)       │               │
│  │  sp-terraform-cloudsec               │               │
│  │  ✓ Contributor role                  │               │
│  │  ✓ Credentials secured               │               │
│  └──────────────┬───────────────────────┘               │
│                 │                                       │
│                 ▼                                       │
│  ┌──────────────────────────────────────┐               │
│  │    Resource Group                    │               │
│  │    rg-cloudsec-labs                  │               │
│  │  ┌────────────────────────────────┐  │               │
│  │  │  Log Analytics Workspace       │  │               │
│  │  │  law-cloudsec-logs             │  │               │
│  │  │  • 90-day retention            │  │               │
│  │  │  • 5GB free ingestion          │  │               │
│  │  └────────────────────────────────┘  │               │
│  └──────────────────────────────────────┘               │
│                                                         │
│  ┌──────────────────────────────────────┐               │
│  │    Activity Logs (Diagnostic)        │               │
│  │  • Administrative events             │               │
│  │  • Security events                   │               │
│  │  • Policy evaluations                │               │
│  │  → law-cloudsec-logs                 │               │
│  └──────────────────────────────────────┘               │
│                                                         │
│  ┌──────────────────────────────────────┐               │
│  │      Cost Management                 │               │
│  │  • Budget: $160/month                │               │
│  │  • Alerts: 50%, 75%, 90%             │               │
│  │  • Credit: $200 (30 days)            │               │
│  └──────────────────────────────────────┘               │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## Verification Steps

To verify baseline security is properly configured:
```bash
# 1. Verify subscription access
az account show --output table

# 2. Verify resource group
az group show --name rg-cloudsec-labs --output table

# 3. Verify Log Analytics workspace
az monitor log-analytics workspace show \
  --resource-group rg-cloudsec-labs \
  --workspace-name law-cloudsec-logs \
  --output table

# 4. Verify diagnostic settings
az monitor diagnostic-settings subscription list --output table

# 5. Verify service principal
az ad sp list --display-name "sp-terraform-cloudsec" --output table

# 6. Check resource providers registered
az provider list --query "[?registrationState=='Registered'].namespace" --output table

# 7. Verify budget (requires portal access)
# Navigate to: Cost Management + Billing → Budgets
```

## Lessons Learned

**What Went Well:**
- Azure CLI installation and login straightforward
- Resource group concept provides clean organization
- Log Analytics workspace setup simple
- Service principal creation successful (unlike student account)

**Key Insights:**
- Azure separates identity (Azure AD) from resources (RBAC)
- Activity Logs analogous to AWS CloudTrail
- Resource groups essential for organization and RBAC scope
- Free account provides full admin capabilities (unlike student account)

**Challenges Overcome:**
- Initial student account lacked service principal permissions
- Switched to free account for full control
- Diagnostic settings CLI syntax less intuitive than portal

**Would Do Differently:**
- Could have scripted entire baseline with Azure CLI
- Might explore ARM templates or Bicep for infrastructure
- Consider Azure DevOps for future CI/CD pipeline

**Skills Demonstrated:**
- Azure account security hardening
- Resource organization and management
- Audit logging configuration
- Service principal management
- Azure CLI proficiency
- Cost management and monitoring

## Azure vs AWS Baseline Comparison

| Feature                   | AWS         | Azure                         | Implementation |
| ------------------------- | ----------- | ----------------------------- | -------------- |
| **Account Security**      | Root MFA    | Account MFA                   | Both ✅         |
| **Admin Identity**        | IAM User    | Azure AD + Service Principal  | Both ✅         |
| **Audit Logging**         | CloudTrail  | Activity Logs + Log Analytics | Both ✅         |
| **Cost Management**       | Budgets     | Cost Management + Budgets     | Both ✅         |
| **Resource Organization** | Tags        | Resource Groups + Tags        | Azure ✅        |
| **Automation Identity**   | Access Keys | Service Principal             | Both ✅         |
| **CLI Tool**              | AWS CLI     | Azure CLI                     | Both ✅         |
| **Free Tier**             | 12 months   | $200 (30 days) + 12 months    | Both ✅         |

**Key Differences:**
- Azure uses resource groups for organization (AWS relies more on tags)
- Azure separates identity provider (Azure AD) from resource authorization (RBAC)
- Azure service principals more structured than AWS access keys
- AWS CloudTrail simpler than Azure Activity Logs + Log Analytics

## Compliance Evidence

This baseline satisfies multiple compliance requirements:

**Microsoft Cloud Security Benchmark:**
- IM-1 - Use centralized identity and authentication
- IM-2 - Protect identity and authentication systems
- LT-1 - Enable threat detection capabilities
- LT-3 - Enable logging for security investigation

**ISO27001:2022:**
- A.9.2.3 - Management of privileged access rights
- A.12.4.1 - Event logging (Activity Logs)
- A.18.1.3 - Protection of records (log retention)

**NIST Cybersecurity Framework:**
- ID.AM-2 - Software platforms and applications managed
- PR.AC-1 - Identities and credentials managed
- DE.AE-3 - Event data collected and correlated
- DE.CM-1 - Network monitored for anomalous activity

## Next Steps

With baseline security established:

1. ✅ Account secured and ready for labs
2. 🚧 Begin Lab 01: Azure AD & RBAC Security
3. 📋 Enable Microsoft Defender in Lab 02
4. 📋 Document RBAC best practices
5. 📋 Create Terraform modules for baseline automation
6. 📋 Compare Azure and AWS security models

## Resources

**Azure Documentation:**
- [Azure Security Best Practices](https://docs.microsoft.com/en-us/azure/security/fundamentals/best-practices-and-patterns)
- [Azure Active Directory Documentation](https://docs.microsoft.com/en-us/azure/active-directory/)
- [Activity Logs Overview](https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/activity-log)
- [Service Principal Management](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal)

**Security Standards:**
- [Microsoft Cloud Security Benchmark](https://docs.microsoft.com/en-us/security/benchmark/azure/)
- [Azure Security Documentation](https://docs.microsoft.com/en-us/azure/security/)

**Cost Management:**
- [Azure Cost Management Documentation](https://docs.microsoft.com/en-us/azure/cost-management-billing/)
- [Azure Free Account FAQ](https://azure.microsoft.com/en-us/free/free-account-faq/)

**Comparison:**
- [AWS to Azure Services Comparison](https://docs.microsoft.com/en-us/azure/architecture/aws-professional/services)

---

**Completed By:** Greg Lewis  
**Completion Date:** January 18, 2026  
**Time Investment:** ~45 minutes  
**Subscription:** Azure for Students / Azure Free Account  
**Next Lab:** [01-iam-security](../01-iam-security/)  
**AWS Parallel:** [aws/00-account-baseline](../../aws/00-account-baseline/)
