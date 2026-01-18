# AWS IAM vs Azure RBAC: A Security Engineer's Comparison

A hands-on comparison of Identity and Access Management (IAM) implementations across AWS and Azure, based on building parallel security auditor roles in both platforms.

**Author:** Greg Lewis  
**Date:** January 2026  
**Labs:** [AWS IAM Security](../aws/01-iam-security/) | [Azure IAM Security](../azure/01-iam-security/)

## Executive Summary

Both AWS and Azure provide robust identity and access management capabilities, but with fundamentally different architectural approaches. AWS combines identity and authorization in IAM, while Azure separates identity (Azure AD) from authorization (RBAC). Understanding these differences is critical for multi-cloud security engineering.

## Architecture Comparison

### AWS IAM Architecture
```
┌─────────────────────────────────────┐
│          AWS IAM                    │
│  (Combined Identity + Authorization)│
├─────────────────────────────────────┤
│                                     │
│  IAM Users ──→ IAM Policies         │
│  IAM Roles ──→ IAM Policies         │
│  IAM Groups ──→ IAM Policies        │
│                                     │
│  Trust Policies (who can assume)    │
│  Permission Policies (what actions) │
│                                     │
└─────────────────────────────────────┘
```

### Azure RBAC Architecture
```
┌─────────────────────────────────────┐
│      Azure AD (Identity)            │
│  ┌───────────────────────────────┐  │
│  │ Users                         │  │
│  │ Groups                        │  │
│  │ Service Principals            │  │
│  │ Managed Identities            │  │
│  └───────────────────────────────┘  │
│              │                      │
│              ▼                      │
│  ┌───────────────────────────────┐  │
│  │   Azure RBAC (Authorization)  │  │
│  │   Role Definitions            │  │
│  │   Role Assignments            │  │
│  │   Scopes (Subscription/RG)    │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

## Key Conceptual Differences

| Concept                    | AWS                               | Azure                                                           | Impact                                            |
| -------------------------- | --------------------------------- | --------------------------------------------------------------- | ------------------------------------------------- |
| **Identity Provider**      | IAM (built-in)                    | Azure Active Directory (separate service)                       | Azure identity spans beyond just Azure resources  |
| **Authorization Model**    | Policy-based (JSON documents)     | Role-based (role definitions + assignments)                     | Azure is more structured, AWS more flexible       |
| **Permission Logic**       | Explicit allow, implicit deny     | Additive (permissions are additive, with deny overriding allow) | Azure requires careful role assignment management |
| **Scope Hierarchy**        | Account → (Org Units) → Resources | Management Group → Subscription → Resource Group → Resource     | Azure has more granular scope options             |
| **Service Authentication** | Instance Profiles / IAM Roles     | Managed Identities                                              | Azure's managed identities are simpler            |

## Terminology Translation

| AWS Term          | Azure Term                                        | Notes                                    |
| ----------------- | ------------------------------------------------- | ---------------------------------------- |
| IAM User          | Azure AD User                                     | Azure AD is enterprise identity platform |
| IAM Group         | Azure AD Group                                    | Azure groups can be dynamic (rule-based) |
| IAM Role          | Azure AD Service Principal + RBAC Role Assignment | Two-step process in Azure                |
| IAM Policy        | RBAC Role Definition                              | Azure roles are reusable templates       |
| Policy Attachment | Role Assignment                                   | Azure explicitly assigns at scope        |
| Account           | Subscription                                      | Azure subscriptions within tenants       |
| -                 | Tenant                                            | No AWS equivalent - identity boundary    |
| Instance Profile  | Managed Identity                                  | Azure identities are first-class objects |
| Access Keys       | Service Principal Credentials                     | Azure also supports certificate auth     |
| Resource Tags     | Resource Tags                                     | Similar tagging capabilities             |

## Implementation Comparison: Security Auditor Role

### What I Built

Both labs created a security auditor identity with read-only access to security services:

**AWS Implementation:**
- Custom IAM policy (JSON document)
- IAM role with MFA-required trust policy
- Policy attachment to role
- Tested with temporary credentials (STS AssumeRole)

**Azure Implementation:**
- Custom RBAC role definition
- Azure AD security group
- Role assignment at subscription scope
- Built-in Security Reader also assigned

### Code Comparison

**AWS - IAM Policy Document (Terraform):**
```hcl
data "aws_iam_policy_document" "security_auditor" {
  statement {
    sid    = "CloudTrailReadAccess"
    effect = "Allow"
    actions = [
      "cloudtrail:DescribeTrails",
      "cloudtrail:GetTrailStatus",
      "cloudtrail:LookupEvents"
    ]
    resources = ["*"]
  }
  
  statement {
    sid    = "DenySecurityModifications"
    effect = "Deny"
    actions = [
      "iam:CreateUser",
      "iam:DeleteUser",
      "cloudtrail:StopLogging"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "security_auditor" {
  name   = "security-auditor-policy"
  policy = data.aws_iam_policy_document.security_auditor.json
}

resource "aws_iam_role" "security_auditor" {
  name               = "security-auditor-role"
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
}

resource "aws_iam_role_policy_attachment" "security_auditor" {
  role       = aws_iam_role.security_auditor.name
  policy_arn = aws_iam_policy.security_auditor.arn
}
```

**Azure - RBAC Role Definition (Terraform):**
```hcl
resource "azurerm_role_definition" "security_auditor" {
  name  = "security-auditor"
  scope = data.azurerm_subscription.current.id
  
  permissions {
    actions = [
      "*/read",
      "Microsoft.Insights/eventtypes/values/read",
      "Microsoft.Security/*/read"
    ]
    
    not_actions = [
      "Microsoft.Authorization/roleAssignments/write",
      "Microsoft.Security/*/write"
    ]
  }
  
  assignable_scopes = [
    data.azurerm_subscription.current.id
  ]
}

resource "azuread_group" "security_auditors" {
  display_name     = "security-auditors"
  security_enabled = true
}

resource "azurerm_role_assignment" "security_auditor" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = azurerm_role_definition.security_auditor.role_definition_resource_id
  principal_id       = azuread_group.security_auditors.object_id
}
```

### Permission Models

**AWS - Explicit Allow/Deny:**
- Default: Implicit deny (no access)
- Must explicitly allow actions
- Explicit deny always wins (overrides allows)
- Evaluation: Deny → Allow → Default Deny

**Azure - Additive with Deny Assignments:**
- Default: No access (no role assignments)
- Roles are additive (multiple assignments combine)
- Most permissive role wins
- Deny Assignments exist but rarely used
- Evaluation: All role assignments combined

**Key Difference:**
In AWS, you might create a policy with both Allow and Deny statements. In Azure, you typically assign multiple roles and they combine additively.

## Real-World Testing Insights

### AWS Testing

**What Worked:**
- Assumed role with MFA requirement
- Temporary credentials (15min - 12hr)
- Read operations succeeded (CloudTrail, IAM)
- Write operations explicitly denied

**Command:**
```bash
aws sts assume-role \
  --role-arn arn:aws:iam::123456789012:role/security-auditor \
  --role-session-name audit-session \
  --serial-number arn:aws:iam::123456789012:mfa/user \
  --token-code 123456
```

### Azure Testing

**What I Learned:**
- Role assignments typically takes 5-10 minutes to propagate, occasionally longer
- Account Owner role overrides read-only restrictions (additive model)
- Would need dedicated test user to properly validate
- Azure AD group membership controls access

**Challenge:**
Testing was complicated by additive permissions - having Owner role meant I couldn't truly test read-only restrictions without creating a separate user.

## Service-to-Service Authentication

### AWS: Instance Profiles & IAM Roles
```hcl
# EC2 instance role
resource "aws_iam_role" "ec2_app" {
  name = "ec2-app-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_app" {
  name = "ec2-app-profile"
  role = aws_iam_role.ec2_app.name
}

# Attach to EC2
resource "aws_instance" "app" {
  iam_instance_profile = aws_iam_instance_profile.ec2_app.name
  # ...
}
```

### Azure: Managed Identities
```hcl
# VM with system-assigned managed identity
resource "azurerm_linux_virtual_machine" "app" {
  name = "app-vm"
  
  identity {
    type = "SystemAssigned"
  }
  # ...
}

# Grant permissions to the identity
resource "azurerm_role_assignment" "vm_storage" {
  scope                = azurerm_storage_account.data.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_linux_virtual_machine.app.identity[0].principal_id
}
```

**Key Difference:**
Azure's managed identities are simpler - they're automatically managed by Azure AD with no credentials to rotate. AWS requires creating a role and instance profile as separate steps.

## Advanced Features Comparison

### Just-in-Time Access

| Feature                 | AWS                                        | Azure                                |
| ----------------------- | ------------------------------------------ | ------------------------------------ |
| **Native JIT**          | No native solution                         | Privileged Identity Management (PIM) |
| **Implementation**      | Custom solution with Lambda/Step Functions | Built-in Azure AD Premium P2 feature |
| **Approval Workflows**  | Custom implementation                      | Native PIM workflows                 |
| **Time-Limited Access** | STS temporary credentials (manual)         | Automatic expiration with PIM        |

**Winner:** Azure (if you have Premium P2)

### Conditional Access

| Feature               | AWS                                                                  | Azure                                       |
| --------------------- | -------------------------------------------------------------------- | ------------------------------------------- |
| **Native Support**    | IAM Conditions (powerful but resource-centric, not identity-centric) | Conditional Access Policies (comprehensive) |
| **MFA Enforcement**   | Per-role condition                                                   | Policy-based across all apps                |
| **Location-Based**    | IP conditions in policies                                            | Full geolocation + named locations          |
| **Device Compliance** | Not supported                                                        | Intune integration                          |
| **Risk-Based**        | Not supported                                                        | Identity Protection integration             |

**Winner:** Azure (much more sophisticated)

### Policy Analysis

| Feature                | AWS                             | Azure                               |
| ---------------------- | ------------------------------- | ----------------------------------- |
| **Tool**               | IAM Access Analyzer             | Access Reviews + Azure AD Reporting |
| **External Access**    | Detects cross-account access    | Detects external user access        |
| **Unused Permissions** | Access Analyzer findings        | Activity logs analysis              |
| **Policy Simulation**  | IAM Policy Simulator            | No direct equivalent                |
| **Recommendations**    | Access Analyzer recommendations | Defender for Cloud recommendations  |

**Winner:** Tie (different strengths)

## Multi-Cloud Security Patterns

### Pattern 1: Least Privilege Security Auditor

**When to Use:** Read-only access for compliance auditing, security reviews

**AWS Implementation:**
- Custom IAM policy with specific read actions
- IAM role with MFA requirement
- Explicit denies for critical modifications

**Azure Implementation:**
- Custom RBAC role with read permissions
- Azure AD group for membership management
- Combine with Security Reader built-in role

**Recommendation:** Implement in both clouds with similar scope

### Pattern 2: Break-Glass Admin Access

**When to Use:** Emergency access when primary authentication fails

**AWS Implementation:**
- Dedicated IAM user with MFA
- Monitored with CloudWatch alarms
- Credentials in secure vault

**Azure Implementation:**
- Emergency access admin account
- Excluded from Conditional Access
- Monitored with Azure AD alerts
- PIM-eligible role

**Recommendation:** Azure's PIM provides better controls if available

### Pattern 3: Service Automation

**When to Use:** Applications needing cloud API access

**AWS Implementation:**
- IAM role for EC2/Lambda/ECS
- Instance profile or execution role
- Least privilege permissions

**Azure Implementation:**
- System-assigned managed identity
- Automatic credential management
- RBAC role assignment at appropriate scope

**Recommendation:** Azure's managed identities are simpler, but both work well

## Cost Considerations

### AWS IAM
- ✅ **Free:** IAM users, roles, policies (unlimited)
- ✅ **Free:** CloudTrail management events
- ✅ **Free:** IAM Access Analyzer
- ✅ **Free:** AWS Organizations
- ❌ **Paid:** Some guardrails (Config, CloudTrail data events, SCP enforcement side effects)
- ❌ **Paid:** CloudTrail data events

### Azure RBAC
- ✅ **Free:** Azure AD Free (basic features)
- ✅ **Free:** RBAC roles and assignments
- ✅ **Free:** Activity Logs (90 days)
- ✅ **Free:** Basic security recommendations
- ❌ **Paid:** Azure AD Premium P1 ($6/user/month) - Conditional Access
- ❌ **Paid:** Azure AD Premium P2 ($9/user/month) - PIM, Identity Protection
- ❌ **Paid:** Log Analytics data ingestion (after 5GB free)

**For Labs:** Both can be implemented at zero cost with free tier features

## Security Best Practices

### Common to Both Platforms

1. **Enable MFA** for all human users (AWS: IAM, Azure: Azure AD)
2. **Use groups** for permission management (AWS: IAM Groups, Azure: Azure AD Groups)
3. **Implement least privilege** (AWS: Custom policies, Azure: Custom roles)
4. **Enable audit logging** (AWS: CloudTrail, Azure: Activity Logs)
5. **Rotate credentials** regularly (AWS: Access keys, Azure: Service principal secrets)
6. **Use service identities** for applications (AWS: IAM roles, Azure: Managed identities)
7. **Monitor privileged access** (AWS: CloudWatch, Azure: Azure Monitor)
8. **Regular access reviews** (AWS: IAM Access Analyzer, Azure: Access Reviews)

### Platform-Specific Best Practices

**AWS:**
- Avoid using root account after initial setup
- Enable IAM Access Analyzer in all regions
- Use permission boundaries for delegated administration
- Implement SCPs in AWS Organizations for guardrails
- Tag all resources for cost allocation and access control

**Azure:**
- Separate duties with Azure AD and RBAC
- Use management groups for policy inheritance
- Implement Conditional Access for risk-based auth
- Enable PIM for just-in-time admin access
- Use Azure Policy for compliance automation

## When to Use Each Platform

### Choose AWS IAM When:
- ✅ Building primarily AWS-native applications
- ✅ Need flexible, granular policy documents
- ✅ Prefer programmatic access patterns
- ✅ Working with AWS-first organizations
- ✅ Policy-as-code is priority (JSON documents in git)

### Choose Azure RBAC When:
- ✅ Microsoft 365 integration required
- ✅ Enterprise identity (Azure AD) already in use
- ✅ Need sophisticated conditional access
- ✅ Prefer structured role-based model
- ✅ Just-in-time access (PIM) is requirement

### Use Both When:
- ✅ Multi-cloud strategy
- ✅ Avoiding vendor lock-in
- ✅ Different workloads suited to each platform
- ✅ Demonstrating cross-platform security skills

## Lessons Learned from Building Both

### What Was Easier in AWS
- Policy syntax more intuitive (for me)
- Testing with temporary credentials straightforward
- Documentation more comprehensive
- Policy simulator helpful for validation

### What Was Easier in Azure
- Managed identities simpler than instance profiles
- Group-based access management more structured
- Subscription/resource group scopes clearer
- Portal UI more intuitive for beginners

### Surprises
- **Azure's additive permissions** made testing harder (Owner role override)
- **AWS's explicit deny** gives more control but adds complexity
- **Terraform providers** both mature and well-documented
- **Both require patience** for propagation (AWS: seconds, Azure: minutes)

## Interview Talking Points

When discussing multi-cloud IAM in interviews:

1. **Architectural Difference:** "AWS combines identity and authorization in IAM, while Azure separates them - Azure AD for identity, RBAC for authorization."

2. **Permission Models:** "AWS uses explicit allow with deny override, Azure uses additive permissions where the most permissive role wins."

3. **Service Auth:** "Azure's managed identities are simpler than AWS instance profiles - no separate role and profile objects to manage."

4. **JIT Access:** "Azure's PIM provides native just-in-time privileged access. In AWS, you'd need to build this with custom Lambda functions."

5. **Hands-On Experience:** "I built parallel security auditor implementations in both platforms using Terraform, which taught me the nuances of each permission model."

## References

**AWS Documentation:**
- [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [IAM Policy Reference](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html)
- [IAM Access Analyzer](https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html)

**Azure Documentation:**
- [Azure RBAC Documentation](https://docs.microsoft.com/en-us/azure/role-based-access-control/)
- [Azure AD Best Practices](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-ops-guide-intro)
- [Managed Identities](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/)

**Security Standards:**
- [CIS AWS Foundations Benchmark](https://www.cisecurity.org/benchmark/amazon_web_services)
- [CIS Azure Foundations Benchmark](https://www.cisecurity.org/benchmark/azure)
- [Microsoft Cloud Security Benchmark](https://docs.microsoft.com/en-us/security/benchmark/azure/)

## Next Steps

- [ ] Implement conditional IAM policies in AWS
- [ ] Explore Azure PIM for just-in-time access
- [ ] Build cross-account role assumption (AWS)
- [ ] Implement managed identity scenarios (Azure)
- [ ] Create privilege escalation detection rules (both platforms)
- [ ] Publish blog series on multi-cloud IAM

---

**Author:** Greg Lewis  
**Portfolio:** [github.com/gregqlewis/cloud-security-labs](https://github.com/gregqlewis/cloud-security-labs)  
**Blog:** [gregqlewis.com](https://gregqlewis.com)  
**Date:** January 2026