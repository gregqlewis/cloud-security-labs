# Lab 00: AWS Account Baseline Security

Initial security configuration establishing foundational controls for all subsequent AWS labs. This baseline implements AWS security best practices before deploying any workloads.

## Overview

**Status:** ✅ Complete  
**Cost:** $0/month (free tier services)  
**Completion Date:** January 2026  
**Account:** greg-cloudsec-lab

## Objectives

- Secure root account and eliminate its usage
- Establish administrative IAM user with MFA
- Enable comprehensive audit logging
- Configure proactive cost monitoring
- Set up AWS CLI for automation

## Implementation Summary

### 1. Root Account Security

**Actions Taken:**
- ✅ Enabled MFA on root account using authenticator app
- ✅ Documented root credentials in password manager
- ✅ Committed to never using root account post-setup

**Rationale:**
Root account has unrestricted access to all AWS resources and billing. Compromise of root credentials could result in complete account takeover. MFA adds critical second factor protection.

**Compliance Mapping:**
- CIS AWS Foundations Benchmark 1.4, 1.5
- ISO27001 A.9.2.3 (Management of privileged access)

### 2. Administrative IAM User Creation

**Actions Taken:**
- ✅ Created IAM user: `greg-admin`
- ✅ Attached `AdministratorAccess` policy
- ✅ Enabled console access with strong password
- ✅ Enforced password change on first login
- ✅ Enabled MFA on administrative user
- ✅ Generated access keys for CLI/Terraform usage

**Configuration Details:**
```bash
# IAM User: greg-admin
# Policies: AdministratorAccess (AWS managed)
# MFA: Enabled (virtual authenticator)
# Access Keys: Created for programmatic access
# Console Access: Enabled with MFA requirement
```

**Security Notes:**
- Administrative access required for initial lab setup
- Will implement least privilege roles in Lab 01
- Access keys stored securely (never committed to git)
- Keys will be rotated every 90 days

**Compliance Mapping:**
- CIS AWS Foundations Benchmark 1.2, 1.3
- NIST CSF PR.AC-1 (Identity management)

### 3. CloudTrail Audit Logging

**Actions Taken:**
- ✅ Created CloudTrail trail: `greg-cloudsec-audit-trail`
- ✅ Enabled for all AWS regions
- ✅ Configured S3 bucket for log storage
- ✅ Enabled log file validation (integrity checking)
- ✅ Enabled encryption (SSE-S3, not SSE-KMS to save costs)

**Trail Configuration:**
```
Trail Name: greg-cloudsec-audit-trail
Multi-Region: Yes
S3 Bucket: aws-cloudtrail-logs-[account-id]-greg-cloudsec
Log File Validation: Enabled
SSE Encryption: SSE-S3 (server-side, default)
Management Events: All (Read/Write)
Data Events: None (to minimize costs)
CloudWatch Logs: Disabled (to minimize costs)
```

**What's Being Logged:**
- All IAM actions (user creation, policy changes, role assumptions)
- EC2 instance lifecycle (launch, stop, terminate)
- Security group modifications
- S3 bucket policy changes
- All API calls to AWS services

**Cost:** $0/month (management events are free tier)

**Why This Matters:**
CloudTrail provides complete audit trail of all AWS API activity. Essential for:
- Security incident investigation
- Compliance auditing (ISO27001, NIST)
- Privilege escalation detection
- Purple team attack/defense documentation

**Compliance Mapping:**
- CIS AWS Foundations Benchmark 3.1-3.11
- ISO27001 A.12.4.1 (Event logging)
- NIST CSF DE.AE-3 (Event data aggregated)

### 4. Billing and Cost Monitoring

**Actions Taken:**
- ✅ Created monthly budget: $10
- ✅ Configured alerts at 50% ($5), 80% ($8), 100% ($10)
- ✅ Added email notifications
- ✅ Enabled free tier usage alerts
- ✅ Configured AWS Cost Explorer access

**Budget Configuration:**
```
Budget Name: cloudsec-labs-monthly
Amount: $10 USD
Period: Monthly
Alerts:
  - 50% threshold ($5) → Email alert
  - 80% threshold ($8) → Email alert
  - 100% threshold ($10) → Email alert
Free Tier Alerts: Enabled
```

**Cost Management Strategy:**
- Maximize AWS Free Tier (12 months)
- Use t2.micro/t3.micro instances only
- Shut down resources when not actively testing
- Regular Cost Explorer reviews
- Tag all resources for cost tracking

**Free Tier Coverage:**
- 750 hours/month EC2 t2.micro (12 months)
- IAM unlimited (always free)
- CloudTrail management events (always free)
- CloudWatch Logs 5GB ingestion (always free)
- GuardDuty 30-day trial

**Compliance Mapping:**
- Financial controls for lab management
- Demonstrates cost optimization skills

### 5. AWS CLI Configuration

**Actions Taken:**
- ✅ Installed AWS CLI v2 on macOS
- ✅ Configured named profile: `cloudsec-lab`
- ✅ Tested CLI authentication
- ✅ Set default region: `us-east-1`

**CLI Configuration:**
```bash
# Profile: cloudsec-lab
# Region: us-east-1 (Virginia - aligns with federal work)
# Output: json
# Authentication: Access keys from greg-admin user

# Test commands executed:
aws sts get-caller-identity --profile cloudsec-lab
aws s3 ls --profile cloudsec-lab
aws cloudtrail describe-trails --profile cloudsec-lab
```

**Usage Pattern:**
```bash
# Always specify profile for lab work
aws [command] --profile cloudsec-lab

# Or export as default for session
export AWS_PROFILE=cloudsec-lab
```

**Security Notes:**
- Access keys stored in `~/.aws/credentials` (chmod 600)
- Never commit credentials to git (.gitignore configured)
- Keys will be rotated every 90 days
- Consider aws-vault for enhanced key management

## Security Baseline Checklist

- ✅ Root account MFA enabled
- ✅ Root account not used for day-to-day operations
- ✅ Administrative IAM user created (greg-admin)
- ✅ IAM user MFA enabled
- ✅ Strong password policy configured (AWS default)
- ✅ CloudTrail enabled (all regions)
- ✅ CloudTrail log validation enabled
- ✅ Billing alerts configured
- ✅ Free tier monitoring enabled
- ✅ AWS CLI installed and configured
- ✅ Access keys secured and documented
- 📋 GuardDuty (will enable in Lab 02)
- 📋 IAM Access Analyzer (will enable in Lab 01)
- 📋 AWS Config (selective rules in future labs)

## What Was NOT Configured (And Why)

**SSE-KMS for CloudTrail:**
- Cost: ~$1/month for KMS key + API call charges
- Decision: SSE-S3 provides adequate encryption for lab purposes
- Future: Could enable in dedicated KMS lab for learning

**CloudWatch Logs Integration:**
- Cost: Data ingestion charges after 5GB free tier
- Decision: Activity logs queryable in CloudTrail console
- Future: Will enable for specific security monitoring in Lab 02

**AWS Config:**
- Cost: ~$2/month for config rules
- Decision: Not required for baseline, will enable selectively
- Future: Specific compliance rules in relevant labs

**Data Events in CloudTrail:**
- Cost: Charges apply for S3/Lambda data events
- Decision: Management events sufficient for security auditing
- Future: Could enable for specific S3 security labs

## Architecture Diagram
```
┌─────────────────────────────────────────────────────────┐
│                 AWS Account Security                    │
│                  greg-cloudsec-lab                      │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌──────────────────────────────────────┐               │
│  │        Root Account                  │               │
│  │  ✓ MFA Enabled                       │               │
│  │  ✗ Not used post-setup               │               │
│  └──────────────────────────────────────┘               │
│                                                         │
│  ┌──────────────────────────────────────┐               │
│  │     IAM User: greg-admin             │               │
│  │  ✓ MFA Enabled                       │               │
│  │  ✓ AdministratorAccess               │               │
│  │  ✓ Console + CLI access              │               │
│  └──────────────┬───────────────────────┘               │
│                 │                                       │
│                 ▼                                       │
│  ┌──────────────────────────────────────┐               │
│  │         CloudTrail                   │               │
│  │  • All regions enabled               │               │
│  │  • Management events logged          │               │
│  │  • Log file validation               │               │
│  │  • S3 bucket (encrypted)             │               │
│  └──────────────────────────────────────┘               │
│                                                         │
│  ┌──────────────────────────────────────┐               │
│  │      Billing & Budgets               │               │
│  │  • $10/month budget                  │               │
│  │  • Alerts: 50%, 80%, 100%            │               │
│  │  • Free tier monitoring              │               │
│  └──────────────────────────────────────┘               │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## Verification Steps

To verify baseline security is properly configured:
```bash
# 1. Verify IAM user and MFA
aws iam get-user --profile cloudsec-lab
aws iam list-mfa-devices --user-name greg-admin --profile cloudsec-lab

# 2. Verify CloudTrail
aws cloudtrail describe-trails --profile cloudsec-lab
aws cloudtrail get-trail-status --name greg-cloudsec-audit-trail --profile cloudsec-lab

# 3. Verify CloudTrail is logging
aws cloudtrail lookup-events --max-results 5 --profile cloudsec-lab

# 4. List S3 bucket for logs
aws s3 ls --profile cloudsec-lab

# 5. Check budgets (via console - no CLI command for free accounts)
# Navigate to: Billing Dashboard → Budgets
```

## Lessons Learned

**What Went Well:**
- MFA setup straightforward with authenticator app
- CloudTrail configuration intuitive in console
- AWS CLI profile management clean and organized
- Free tier provides generous resources for learning

**Key Insights:**
- Security baseline must precede workload deployment
- CloudTrail free tier (management events) provides excellent value
- Budget alerts essential for cost control in learning environment
- IAM user immediately preferable to root account usage

**Would Do Differently:**
- Could have scripted entire baseline with AWS CLI
- Might document root account setup steps in private notes
- Consider using AWS Organizations for future multi-account scenarios

**Skills Demonstrated:**
- AWS account security hardening
- IAM user and access management
- Audit logging configuration
- Cost management and monitoring
- AWS CLI proficiency

## Compliance Evidence

This baseline satisfies multiple compliance requirements:

**CIS AWS Foundations Benchmark:**
- 1.2 - MFA enabled for console passwords
- 1.3 - Credentials unused for 90 days are disabled
- 1.4 - Access keys rotated every 90 days
- 1.5 - IAM password policy configured
- 3.1 - CloudTrail enabled in all regions
- 3.2 - CloudTrail log file validation enabled

**ISO27001:2022:**
- A.9.2.3 - Management of privileged access rights
- A.12.4.1 - Event logging (CloudTrail)
- A.18.1.3 - Protection of records (log retention)

**NIST Cybersecurity Framework:**
- ID.AM-2 - Software platforms managed
- PR.AC-1 - Identities and credentials managed
- DE.AE-3 - Event data collected and correlated

## Next Steps

With baseline security established:

1. ✅ Account secured and ready for labs
2. 🚧 Begin Lab 01: IAM Security Deep Dive
3. 📋 Enable GuardDuty in Lab 02: Security Monitoring
4. 📋 Document IAM best practices
5. 📋 Create Terraform modules for baseline automation

## Resources

**AWS Documentation:**
- [AWS Account Security Best Practices](https://docs.aws.amazon.com/accounts/latest/reference/best-practices.html)
- [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [CloudTrail User Guide](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/)
- [AWS Free Tier](https://aws.amazon.com/free/)

**Security Standards:**
- [CIS AWS Foundations Benchmark v1.5](https://www.cisecurity.org/benchmark/amazon_web_services)
- [AWS Well-Architected Security Pillar](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)

**Cost Management:**
- [AWS Cost Management Documentation](https://docs.aws.amazon.com/cost-management/)
- [AWS Budgets](https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-managing-costs.html)

---

**Completed By:** Greg Lewis  
**Completion Date:** January 18, 2026  
**Time Investment:** ~30 minutes  
**Account:** greg-cloudsec-lab  
**Next Lab:** [01-iam-security](../01-iam-security/)