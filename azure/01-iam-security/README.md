# Lab 01: Azure AD & RBAC Security Deep Dive

Comprehensive Identity and Access Management implementation demonstrating Azure Active Directory, Role-Based Access Control, Conditional Access, and Privileged Identity Management using Infrastructure as Code.

## Lab Overview

**Status:** 📋 Planned  
**Cost:** $0-10/month (some premium features may require Azure AD P2)  
**Duration:** 2-3 sessions  
**Prerequisites:** Account baseline security completed

## Objectives

### Primary Goals
1. Implement Azure AD user and group management with Terraform
2. Configure Role-Based Access Control (RBAC) with custom roles
3. Set up Conditional Access policies for risk-based authentication
4. Explore Privileged Identity Management (PIM) for just-in-time access
5. Create managed identities for secure service authentication
6. Document privilege escalation paths and mitigations

### Learning Outcomes
- Design identity architectures aligned with zero-trust principles
- Implement Azure AD security features (MFA, Conditional Access)
- Write custom RBAC roles for least privilege
- Automate identity management with Terraform
- Map Azure identity security to compliance frameworks (ISO27001, NIST)
- Compare Azure AD/RBAC vs AWS IAM patterns

## Architecture
```
┌─────────────────────────────────────────────────────────┐
│                   Azure Subscription                    │
│                                                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌──────────────────────────────────────┐               │
│  │         Azure Active Directory       │               │
│  ├──────────────────────────────────────┤               │
│  │ • Users & Groups                     │               │
│  │ • Conditional Access                 │               │
│  │ • MFA Enforcement                    │               │
│  │ • Privileged Identity Management     │               │
│  └──────────────┬───────────────────────┘               │
│                 │                                       │
│                 ▼                                       │
│  ┌──────────────────────────────────────┐               │
│  │    RBAC Role Assignments             │               │
│  ├──────────────────────────────────────┤               │
│  │ • Built-in roles                     │               │
│  │ • Custom roles (least privilege)     │               │
│  │ • Scope-based assignments            │               │
│  │   (Subscription/RG/Resource level)   │               │
│  └──────────────┬───────────────────────┘               │
│                 │                                       │
│                 ▼                                       │
│  ┌──────────────────────────────────────┐               │
│  │      Managed Identities              │               │
│  ├──────────────────────────────────────┤               │
│  │ • System-assigned (VMs, Functions)   │               │
│  │ • User-assigned (shared identity)    │               │
│  └──────────────────────────────────────┘               │
│                                                         │
│  ┌──────────────────────────────────────┐               │
│  │      Activity Logs & Monitoring      │               │
│  │  (Identity & Access audit trail)     │               │
│  └──────────────────────────────────────┘               │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## Implementation Plan

### Phase 1: Azure AD User & Group Management
**Deliverables:**
- Azure AD users for different personas
- Security groups for role assignment
- MFA enforcement policies
- Password policies and lifecycle management

**Scenarios:**
1. **Security Auditor User**
   - Azure AD user with MFA required
   - Reader role at subscription level
   - Can view all resources, cannot modify
   - Conditional Access based on location

2. **Developer User**
   - Contributor role scoped to specific resource groups
   - Cannot modify networking or security
   - MFA required for privileged actions
   - Access restricted to approved IPs

3. **Security Groups**
   - `sg-security-team` - Security Hub access
   - `sg-developers` - Development resource access
   - `sg-admins` - Privileged access (with PIM)
   - Dynamic group membership rules

### Phase 2: Custom RBAC Roles
**Deliverables:**
- Custom role definitions for specific scenarios
- Least privilege role assignments
- Scope-based permissions (subscription, RG, resource)
- Role assignment conditions

**Implementations:**
1. **Custom Security Auditor Role**
   - Read access to security services (Defender, Sentinel)
   - Activity Log read access
   - No write permissions anywhere
   - Assignable at subscription scope

2. **VM Operator Role**
   - Can start/stop VMs
   - Cannot create/delete VMs
   - Cannot modify networking
   - Scoped to specific resource groups

3. **Storage Backup Role**
   - Write to specific storage accounts
   - Cannot delete blobs (immutable storage)
   - List and read permissions
   - Scoped to backup containers only

4. **Function App Developer**
   - Deploy Azure Functions
   - Manage App Service Plans
   - Cannot modify RBAC or networking
   - CloudWatch equivalent log access

### Phase 3: Conditional Access & PIM
**Deliverables:**
- Conditional Access policies for risk-based auth
- Privileged Identity Management configuration
- Just-in-time admin access workflows
- Sign-in risk detection and response

**Implementations:**
1. **Conditional Access Policies**
   - Require MFA for all users
   - Block legacy authentication
   - Require compliant devices for admin access
   - Location-based access (block high-risk countries)
   - Risk-based policies (sign-in risk, user risk)

2. **Privileged Identity Management (PIM)**
   - Just-in-time activation for admin roles
   - Time-bound role assignments
   - Approval workflows for elevation
   - Audit trail of privileged access
   - Alert on suspicious privilege usage

3. **Identity Protection**
   - Risk detection (leaked credentials, anomalous travel)
   - Automated remediation (require password reset)
   - Investigation workflows

### Phase 4: Managed Identities & Service Authentication
**Deliverables:**
- System-assigned managed identities for VMs
- User-assigned managed identities for functions
- Service principal alternatives
- Secure application authentication patterns

**Implementations:**
1. **VM with Managed Identity**
   - System-assigned identity for Azure VM
   - RBAC to access Key Vault secrets
   - No credentials stored on VM
   - Access Azure services securely

2. **Function App with User-Assigned Identity**
   - Shared identity across multiple functions
   - Access to Storage Account and SQL Database
   - Lifecycle independent of function app
   - Terraform-managed identity

3. **Cross-Resource Access**
   - Managed identity accessing Storage
   - Managed identity accessing Key Vault
   - Managed identity for Azure SQL authentication
   - Demonstrate least privilege access patterns

### Phase 5: Infrastructure as Code
**Deliverables:**
- Terraform modules for Azure AD resources
- Reusable RBAC templates
- Automated identity deployment
- CI/CD integration patterns

**Module Structure:**
```
terraform/
├── main.tf              # Root configuration
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── versions.tf          # Provider versions
├── modules/
│   ├── azure-ad-user/   # User creation module
│   ├── rbac-role/       # Custom role module
│   ├── role-assignment/ # Assignment module
│   └── managed-identity/ # Managed identity module
└── examples/
    ├── security-auditor/
    ├── vm-operator/
    └── function-identity/
```

## MITRE ATT&CK Mapping

### Techniques Demonstrated

**T1078 - Valid Accounts**
- Detection: Unusual sign-in locations, impossible travel
- Mitigation: MFA, Conditional Access, Identity Protection

**T1098 - Account Manipulation**
- Detection: RBAC role assignment changes in Activity Logs
- Mitigation: PIM approval workflows, audit alerts

**T1136 - Create Account**
- Detection: New Azure AD user creation events
- Mitigation: Least privilege for user management roles

**T1548 - Abuse Elevation Control Mechanism**
- Detection: Unauthorized PIM activations
- Mitigation: Approval workflows, time-limited elevation

**T1550 - Use Alternate Authentication Material**
- Detection: Service principal key usage anomalies
- Mitigation: Managed identities (no keys), key rotation

## Security Best Practices Demonstrated

### Identity Foundation
- ✅ MFA required for all users (Conditional Access)
- ✅ No permanent admin assignments (use PIM)
- ✅ Azure AD users for individuals, managed identities for services
- ✅ Password policies enforced (complexity, expiration)
- ✅ Legacy authentication protocols blocked

### Least Privilege
- ✅ Custom RBAC roles over built-in (when appropriate)
- ✅ Scope assignments to minimum required level
- ✅ Just-in-time access with PIM
- ✅ Conditions on role assignments
- ✅ Managed identities over service principals

### Monitoring & Auditing
- ✅ Activity Logs capture all identity operations
- ✅ Sign-in logs analyzed for anomalies
- ✅ PIM audit trail for privileged access
- ✅ Automated alerts for suspicious activity
- ✅ Regular access reviews

### Automation Security
- ✅ Managed identities for Azure resources
- ✅ Service principals with least privilege (when required)
- ✅ Certificate-based auth over secrets
- ✅ Terraform state encrypted and secured
- ✅ Secrets in Key Vault, never in code

## Compliance Mapping

### ISO27001:2022
- **A.9.2.1** - User registration and de-registration
- **A.9.2.2** - User access provisioning
- **A.9.2.3** - Management of privileged access rights
- **A.9.2.5** - Review of user access rights
- **A.9.4.1** - Information access restriction

### NIST CSF
- **PR.AC-1** - Identities and credentials managed
- **PR.AC-4** - Access permissions managed
- **PR.AC-6** - Identities are proofed and bound to credentials
- **DE.CM-3** - Personnel activity is monitored

### Microsoft Cloud Security Benchmark
- **IM-1** - Use centralized identity and authentication system
- **IM-2** - Protect identity and authentication systems
- **IM-3** - Manage application identities securely
- **PA-1** - Separate and limit highly privileged/administrative users
- **PA-2** - Avoid standing access for user accounts and permissions

## Lab Exercises

### Exercise 1: Custom RBAC Role Creation
**Task:** Create a custom role for security operations

**Requirements:**
- Read access to Defender for Cloud, Sentinel
- Activity Log read access
- No write permissions anywhere
- Assignable at subscription scope

**Deliverable:** Terraform configuration + role definition JSON

### Exercise 2: Conditional Access Policy
**Task:** Implement risk-based authentication

**Requirements:**
- Require MFA for all users
- Block access from specific countries
- Require compliant devices for admins
- Allow trusted locations to bypass MFA

**Deliverable:** Conditional Access policy documentation

### Exercise 3: Managed Identity Implementation
**Task:** Create VM with managed identity for Key Vault access

**Requirements:**
- System-assigned managed identity
- RBAC assignment to read secrets from Key Vault
- Test secret retrieval from VM
- No credentials stored on VM

**Deliverable:** Terraform + test script

### Exercise 4: PIM Just-In-Time Access
**Task:** Configure time-limited admin access

**Requirements:**
- PIM role assignment for Contributor
- 4-hour time limit
- Approval workflow (if multi-user)
- Audit trail of activations

**Deliverable:** PIM configuration + documentation

### Exercise 5: Privilege Escalation Detection
**Task:** Simulate and detect RBAC privilege escalation

**Attack Path:**
1. User with `Microsoft.Authorization/roleAssignments/write` at RG level
2. Assigns Owner role to themselves at subscription level
3. Activity Log captures the event
4. Alert triggers for unauthorized role assignment

**Deliverable:** Attack documentation + detection rule

## Azure vs AWS IAM Comparison

| Feature                | AWS                      | Azure                        | Implementation |
| ---------------------- | ------------------------ | ---------------------------- | -------------- |
| **Identity Service**   | IAM                      | Azure AD + RBAC              | Lab Phase 1    |
| **Users**              | IAM Users                | Azure AD Users               | Phase 1        |
| **Roles**              | IAM Roles                | RBAC Roles                   | Phase 2        |
| **Policies**           | IAM Policies             | RBAC Role Definitions        | Phase 2        |
| **MFA**                | IAM MFA                  | Azure AD MFA                 | Phase 1        |
| **JIT Access**         | Manual (Session Manager) | PIM                          | Phase 3        |
| **Service Auth**       | Instance Profiles        | Managed Identities           | Phase 4        |
| **Conditional Access** | IAM Conditions           | Conditional Access Policies  | Phase 3        |
| **Privilege Analysis** | Access Analyzer          | PIM Access Reviews           | Phase 3        |
| **Audit Logs**         | CloudTrail               | Activity Logs + Sign-in Logs | Baseline       |

**Key Differences:**
- Azure separates identity (Azure AD) from authorization (RBAC)
- AWS combines both in IAM
- Azure PIM provides native just-in-time access
- Azure Conditional Access is more granular than IAM conditions
- Azure managed identities simpler than AWS instance profiles

## Documentation Structure
```
01-iam-security/
├── README.md (this file)
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── modules/
│   └── examples/
├── docs/
│   ├── setup-guide.md
│   ├── rbac-role-examples.md
│   ├── privilege-escalation-paths.md
│   ├── conditional-access-policies.md
│   ├── managed-identities-guide.md
│   ├── aws-vs-azure-comparison.md
│   └── lessons-learned.md
├── roles/
│   ├── security-auditor-role.json
│   ├── vm-operator-role.json
│   └── storage-backup-role.json
└── screenshots/
    ├── azure-ad-users.png
    ├── rbac-assignments.png
    ├── conditional-access.png
    ├── pim-activation.png
    └── managed-identity-rbac.png
```

## Tools & Technologies

**Azure Services:**
- Azure Active Directory (Azure AD)
- Azure RBAC (Role-Based Access Control)
- Conditional Access
- Privileged Identity Management (PIM)
- Azure AD Identity Protection
- Managed Identities
- Activity Logs & Sign-in Logs

**Development Tools:**
- Terraform (Infrastructure as Code)
- Azure CLI
- Azure Portal
- VS Code with Azure extensions

**Testing & Validation:**
- Azure AD sign-in logs
- Activity Log queries
- RBAC effective permissions view
- PIM audit reports

## Success Criteria

- [ ] All RBAC roles follow least privilege principle
- [ ] MFA enforced via Conditional Access
- [ ] Custom roles created for specific scenarios
- [ ] Managed identities used instead of service principals
- [ ] PIM configured for admin access
- [ ] Privilege escalation paths documented and mitigated
- [ ] Activity Logs capture all identity changes
- [ ] Automated alerts for suspicious RBAC activity
- [ ] Terraform manages all identity resources
- [ ] Documentation includes AWS comparison
- [ ] Blog post published covering key learnings

## Testing Notes

**Role Permission Testing:**
- Created custom Security Auditor RBAC role with read-only permissions
- Assigned to Azure AD security group at subscription scope
- Also assigned built-in Security Reader role for comprehensive coverage

**Important Note on Testing:**
As the account owner, I have the Owner role on the subscription, which provides full access. Azure RBAC is **additive** - the most permissive role applies. Therefore:
- My account: Owner role (full access) + Security Auditor role (read-only) = Full access
- Dedicated security analyst: Only Security Auditor role = Read-only access

**Key Learning:**
This demonstrates Azure's additive permission model, where multiple role assignments combine with the highest privilege winning. In production environments, security analysts would have only the Security Auditor group membership without Owner privileges, properly enforcing least privilege.

**Role Verification:**
- Custom role definition proves least privilege design
- Explicit denies for role modifications and security changes
- Read-only actions for monitoring and auditing
- Works correctly when assigned to users without administrative roles

## Timeline

**Week 1:**
- Phase 1: Azure AD User & Group Management
- Exercise 1: Custom RBAC Role Creation
- Exercise 2: Conditional Access Policy

**Week 2:**
- Phase 2: Custom RBAC Roles
- Phase 4: Managed Identities
- Exercise 3: Managed Identity Implementation

**Week 3:**
- Phase 3: Conditional Access & PIM
- Exercise 4: PIM Just-In-Time Access
- Exercise 5: Privilege Escalation Detection

**Week 4:**
- Phase 5: Terraform Automation
- AWS vs Azure comparison documentation
- Screenshots and architecture diagrams
- Blog post

## Cost Considerations

**Free Tier:**
- Azure AD Free: Basic identity features
- Activity Logs: Included
- RBAC: No additional cost
- Managed Identities: Free

**Premium Features (Optional):**
- Azure AD Premium P1: $6/user/month
  - Conditional Access
  - Group-based licensing
- Azure AD Premium P2: $9/user/month
  - Privileged Identity Management (PIM)
  - Identity Protection
  - Access Reviews

**Budget Strategy:**
- Start with free tier features
- Document premium features conceptually
- Consider 1-month P2 trial if available
- Focus on RBAC and managed identities (free)

**Target Cost:** $0-10/month

## Next Steps

1. ✅ Complete account baseline
2. ✅ Set up Terraform project structure
3. ✅ Create custom RBAC role (Security Auditor)
4. ✅ Create Azure AD security group
5. ✅ Assign roles at subscription scope
6. ✅ Test and document role behavior
7. ✅ Create comparison documentation (AWS IAM vs Azure RBAC)
8. 🚧 Build additional custom roles (VM Operator, Storage Reader)
9. 📋 Implement managed identity examples
10. 📋 Document privilege escalation scenarios
11. 📋 Publish blog post: "AWS IAM vs Azure RBAC - A Security Engineer's Comparison"

## Resources

**Azure Documentation:**
- [Azure AD Best Practices](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/)
- [Azure RBAC Documentation](https://docs.microsoft.com/en-us/azure/role-based-access-control/)
- [Conditional Access](https://docs.microsoft.com/en-us/azure/active-directory/conditional-access/)
- [Privileged Identity Management](https://docs.microsoft.com/en-us/azure/active-directory/privileged-identity-management/)
- [Managed Identities](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/)

**Security Guidance:**
- [Microsoft Cloud Security Benchmark](https://docs.microsoft.com/en-us/security/benchmark/azure/)
- [Azure AD Security Operations Guide](https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/security-operations-introduction)
- [MITRE ATT&CK - Cloud Matrix](https://attack.mitre.org/matrices/enterprise/cloud/)

**Terraform:**
- [AzureRM Provider - Azure AD](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs)
- [AzureRM Provider - RBAC](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment)

---

**Lab Author:** Greg Lewis  
**Created:** January 2026  
**Last Updated:** January 2026  
**Status:** Planned  
**AWS Parallel:** [aws/01-iam-security](../../aws/01-iam-security/)
