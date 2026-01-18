# Lab 01: IAM Security Deep Dive

Comprehensive Identity and Access Management implementation demonstrating least privilege, role-based access control, privilege escalation detection, and secure automation patterns using Infrastructure as Code.

## Lab Overview

**Status:** 🚧 In Progress  
**Cost:** $0/month (IAM is always free)  
**Duration:** 2-3 sessions  
**Prerequisites:** Account baseline security completed

## Objectives

### Primary Goals
1. Implement least privilege IAM policies using Terraform
2. Configure IAM Access Analyzer for privilege detection
3. Create secure service roles for Lambda and EC2
4. Document common privilege escalation paths and mitigations
5. Build reusable IAM Terraform modules
6. Demonstrate MFA enforcement and conditional access patterns

### Learning Outcomes
- Design IAM architectures aligned with zero-trust principles
- Write custom IAM policies for specific use cases
- Identify and prevent IAM misconfigurations
- Automate IAM deployment with Terraform
- Map IAM security to compliance frameworks (ISO27001, NIST)

## Architecture
```
┌─────────────────────────────────────────────────────────┐
│                    AWS Account                          │
│                 greg-cloudsec-lab                       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌──────────────┐         ┌──────────────┐              │
│  │ IAM Users    │         │ IAM Roles    │              │
│  ├──────────────┤         ├──────────────┤              │
│  │ greg-admin   │────────▶│ lambda-exec  │              │
│  │ (MFA req'd)  │         │ ec2-ssm      │              │
│  │              │         │ cross-acct   │              │
│  └──────────────┘         └──────────────┘              │
│         │                        │                      │
│         │                        │                      │
│         ▼                        ▼                      │
│  ┌──────────────────────────────────────┐               │
│  │     IAM Policies (Least Privilege)   │               │
│  ├──────────────────────────────────────┤               │
│  │ • Custom policies                    │               │
│  │ • Permission boundaries              │               │
│  │ • Conditional policies (MFA, IP)     │               │
│  │ • Service control policies           │               │
│  └──────────────────────────────────────┘               │
│                     │                                   │
│                     ▼                                   │
│  ┌──────────────────────────────────────┐               │
│  │      IAM Access Analyzer             │               │
│  │  (Detects excessive permissions)     │               │
│  └──────────────────────────────────────┘               │
│                                                         │
│  ┌──────────────────────────────────────┐               │
│  │         CloudTrail                   │               │
│  │    (IAM event logging)               │               │
│  └──────────────────────────────────────┘               │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## Implementation Plan

### Phase 1: IAM Policy Development
**Deliverables:**
- Custom IAM policies for common scenarios
- Least privilege policy examples
- Permission boundaries for delegated admin
- Conditional policies (MFA enforcement, IP restrictions)

**Scenarios:**
1. **Read-Only Security Auditor Policy**
   - CloudTrail, GuardDuty, Config read access
   - No write permissions
   - Useful for compliance reviews

2. **EC2 Admin with Restrictions**
   - Can launch/stop instances
   - Cannot modify security groups
   - Cannot disable CloudTrail

3. **Lambda Developer Policy**
   - Deploy Lambda functions
   - Create execution roles with boundaries
   - Access CloudWatch Logs

4. **S3 Backup Operator**
   - Write to specific S3 backup buckets
   - Cannot delete objects (versioning protection)
   - Encrypted uploads required

### Phase 2: Role-Based Access Control
**Deliverables:**
- Service roles for automation (Lambda, EC2)
- Cross-account access roles
- Role assumption chains
- Trust policies and conditions

**Implementations:**
1. **Lambda Execution Role**
   - Minimal CloudWatch Logs permissions
   - Specific resource access only
   - No wildcard permissions

2. **EC2 Instance Role (SSM Access)**
   - Systems Manager for secure shell access
   - No SSH keys required
   - CloudWatch agent permissions

3. **Cross-Account Read Role**
   - Simulate multi-account architecture
   - External ID for security
   - Limited scope permissions

### Phase 3: Security Monitoring & Detection
**Deliverables:**
- IAM Access Analyzer configuration
- CloudTrail IAM event filtering
- Privilege escalation detection scenarios
- Automated alerting for policy changes

**Detection Scenarios:**
1. **Privilege Escalation Paths**
   - `iam:PutUserPolicy` abuse
   - `iam:AttachUserPolicy` with admin policy
   - `iam:CreateAccessKey` for other users
   - Role assumption chain exploitation

2. **Policy Change Monitoring**
   - EventBridge rules for IAM modifications
   - SNS alerts for critical changes
   - CloudTrail log analysis

3. **Access Analyzer Findings**
   - Publicly accessible resources
   - Cross-account access
   - Unused credentials detection

### Phase 4: Infrastructure as Code
**Deliverables:**
- Terraform modules for IAM resources
- Reusable policy templates
- Automated IAM deployment
- CI/CD integration patterns

**Module Structure:**
```
terraform/
├── main.tf              # Root configuration
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── versions.tf          # Provider versions
├── modules/
│   ├── iam-user/       # User creation module
│   ├── iam-role/       # Role creation module
│   ├── iam-policy/     # Policy module
│   └── access-analyzer/ # Access Analyzer setup
└── examples/
    ├── lambda-role/
    ├── ec2-role/
    └── cross-account/
```

## MITRE ATT&CK Mapping

### Techniques Demonstrated

**T1078 - Valid Accounts**
- Detection: Unusual IAM role assumptions
- Mitigation: MFA enforcement, conditional policies

**T1098 - Account Manipulation**
- Detection: IAM policy modifications
- Mitigation: Permission boundaries, SCPs

**T1136 - Create Account**
- Detection: New IAM user creation events
- Mitigation: Least privilege for IAM admin

**T1550 - Use Alternate Authentication Material**
- Detection: Access key usage patterns
- Mitigation: Temporary credentials (STS), key rotation

## Security Best Practices Demonstrated

### Identity Foundation
- ✅ MFA required for all human users
- ✅ No root account usage post-setup
- ✅ IAM users for individuals, roles for services
- ✅ Access keys rotated every 90 days
- ✅ Password policy enforced (complexity, rotation)

### Least Privilege
- ✅ Custom policies over AWS managed (when appropriate)
- ✅ Permission boundaries for delegated administration
- ✅ Deny policies for critical protections
- ✅ Time-based access with session policies
- ✅ Resource-level permissions specified

### Monitoring & Auditing
- ✅ IAM Access Analyzer enabled
- ✅ CloudTrail logging all IAM events
- ✅ Automated alerts for policy changes
- ✅ Regular access reviews (unused credentials)
- ✅ Privilege escalation path analysis

### Automation Security
- ✅ Service roles with minimal permissions
- ✅ External IDs for third-party access
- ✅ Session tags for attribution
- ✅ Terraform state encryption
- ✅ Secrets never in code (AWS Secrets Manager)

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

### AWS Well-Architected (Security Pillar)
- **SEC 2** - How do you manage identities for people and machines?
- **SEC 3** - How do you manage permissions for people and machines?

## Lab Exercises

### Exercise 1: Custom Policy Creation
**Task:** Create a custom policy for a security auditor role

**Requirements:**
- Read access to security services (GuardDuty, Security Hub, Config)
- CloudTrail read access
- No write permissions anywhere
- MFA required for console access

**Deliverable:** Terraform configuration + policy JSON

### Exercise 2: Privilege Escalation Simulation
**Task:** Demonstrate and detect IAM privilege escalation

**Attack Path:**
1. User with `iam:PutUserPolicy` permission
2. Attaches admin policy to themselves
3. CloudTrail captures the event
4. EventBridge rule triggers alert

**Deliverable:** Attack documentation + detection rule

### Exercise 3: Cross-Account Access
**Task:** Set up secure cross-account role assumption

**Requirements:**
- External ID for security
- Least privilege permissions
- MFA required for assumption
- CloudTrail logging in both accounts

**Deliverable:** Terraform + trust policy documentation

### Exercise 4: Service Role Hardening
**Task:** Create Lambda execution role with minimal permissions

**Requirements:**
- Specific DynamoDB table access only
- CloudWatch Logs write access
- No wildcard permissions
- Resource-level policies

**Deliverable:** Terraform module + test Lambda function

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
│   ├── policy-examples.md
│   ├── privilege-escalation-paths.md
│   ├── detection-strategies.md
│   └── lessons-learned.md
├── policies/
│   ├── auditor-policy.json
│   ├── lambda-exec-policy.json
│   └── ec2-ssm-policy.json
└── screenshots/
    ├── access-analyzer-findings.png
    ├── cloudtrail-iam-events.png
    └── policy-simulator-results.png
```

## Tools & Technologies

**AWS Services:**
- IAM (Identity and Access Management)
- IAM Access Analyzer
- CloudTrail
- EventBridge
- SNS (for alerting)
- AWS STS (Security Token Service)

**Development Tools:**
- Terraform (Infrastructure as Code)
- AWS CLI
- IAM Policy Simulator
- VS Code with Terraform extension

**Testing & Validation:**
- AWS Policy Simulator
- IAM Access Analyzer
- Manual privilege escalation testing
- Terraform plan/apply workflows

## Success Criteria

- [ ] All IAM policies follow least privilege principle
- [ ] IAM Access Analyzer shows no critical findings
- [ ] MFA enforced for all human users
- [ ] Service roles have minimal, resource-specific permissions
- [ ] Privilege escalation paths documented and mitigated
- [ ] CloudTrail captures all IAM changes
- [ ] Automated alerts for suspicious IAM activity
- [ ] Terraform manages all IAM resources (no manual changes)
- [ ] Documentation includes compliance mappings
- [ ] Blog post published covering key learnings

## Timeline

**Week 1:**
- Phase 1: IAM Policy Development
- Exercise 1: Custom Policy Creation

**Week 2:**
- Phase 2: Role-Based Access Control
- Exercise 3: Cross-Account Access
- Exercise 4: Service Role Hardening

**Week 3:**
- Phase 3: Security Monitoring & Detection
- Exercise 2: Privilege Escalation Simulation

**Week 4:**
- Phase 4: Terraform Automation
- Documentation and blog post
- Screenshots and architecture diagrams

## Next Steps

1. ✅ Set up Terraform project structure
2. ✅ Create first custom IAM policy (Security Auditor)
3. ✅ Enable IAM Access Analyzer
4. 🚧 Create IAM role using the security auditor policy
5. 📋 Test role permissions and document behavior
6. 📋 Build detection rules for privilege escalation
7. 📋 Create additional custom policies (VM Operator, Lambda Developer)
8. 📋 Implement cross-account role assumption example
9. 📋 Document findings and lessons learned
10. 📋 Publish blog post: "Building Least-Privilege IAM Policies with Terraform"

## Resources

**AWS Documentation:**
- [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [IAM Policy Reference](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html)
- [IAM Access Analyzer](https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html)

**Security Guidance:**
- [MITRE ATT&CK - Cloud IAM](https://attack.mitre.org/tactics/TA0001/)
- [AWS Security Hub - IAM Checks](https://docs.aws.amazon.com/securityhub/latest/userguide/iam-controls.html)
- [CIS AWS Foundations Benchmark](https://www.cisecurity.org/benchmark/amazon_web_services)

**Terraform:**
- [AWS Provider - IAM Resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)
- [Terraform IAM Best Practices](https://www.terraform.io/docs/language/settings/backends/s3.html)

---

**Lab Author:** Greg Lewis  
**Created:** January 2026  
**Last Updated:** January 2026  
**Status:** In Progress