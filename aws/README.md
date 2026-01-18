# AWS Security Labs

Hands-on AWS security implementations focusing on IAM, monitoring, network security, and purple team methodologies aligned with federal cloud security requirements.

## Overview

These labs demonstrate practical AWS security engineering skills using Infrastructure as Code, with emphasis on:
- Zero-trust identity and access management
- Security monitoring and threat detection
- Compliance-aligned configurations (NIST, ISO27001)
- Purple team attack/defense scenarios
- Cost-optimized security implementations

## Account Information

**Account Name:** greg-cloudsec-lab  
**Primary Region:** us-east-1 (federal market alignment)  
**Budget:** $10/month with alerts at 50%, 80%, 100%  
**Baseline Security:**
- Root account MFA enabled
- CloudTrail logging (all regions)
- Billing alerts configured
- IAM admin user with MFA
- Free tier usage monitoring

## Labs

### [00 - Account Baseline](00-account-baseline/)
**Status:** ✅ Complete  
**Focus:** Initial security configuration and foundational controls

**Implemented:**
- Root account hardening with MFA
- Administrative IAM user creation
- CloudTrail audit logging (all regions)
- Billing budget and alerts
- Free tier monitoring
- AWS CLI configuration

**Cost:** $0/month (free tier)

**Key Learnings:**
- Account security must precede any resource deployment
- CloudTrail provides foundational audit capability at no cost
- Proactive budget monitoring prevents cost overruns
- MFA enforcement is non-negotiable for privileged access

---

### [01 - IAM Security](01-iam-security/)
**Status:** 🚧 In Progress  
**Focus:** Identity and access management deep dive

**Objectives:**
- Implement least privilege IAM policies
- Configure IAM Access Analyzer for privilege detection
- Create secure service roles for automation
- Document privilege escalation paths and mitigations
- Build reusable Terraform IAM modules
- Demonstrate MFA enforcement patterns

**Technologies:**
- AWS IAM (policies, roles, users, groups)
- IAM Access Analyzer
- Terraform for IaC
- AWS STS for role assumption
- CloudTrail for IAM event monitoring

**Planned Scenarios:**
- Cross-account access with role assumption
- Service principal least privilege
- Conditional IAM policies (MFA, IP restrictions)
- Permission boundaries for delegated administration
- Detecting and preventing privilege escalation

**Cost:** $0/month (IAM is free)

---

### 02 - Security Monitoring & Detection
**Status:** 📋 Planned  
**Focus:** SIEM integration and threat detection

**Planned Implementation:**
- GuardDuty threat detection (30-day free trial)
- EventBridge rules for security automation
- CloudWatch Logs Insights for threat hunting
- SNS alerts for critical security events
- Integration with home lab Wazuh SIEM
- Custom detection rules for cloud-specific threats

**Technologies:**
- AWS GuardDuty
- Amazon EventBridge
- CloudWatch Logs
- AWS SNS
- Lambda for automated response
- Terraform automation

**MITRE ATT&CK Focus:**
- T1078 - Valid Accounts
- T1530 - Data from Cloud Storage Object
- T1087 - Account Discovery
- T1069 - Permission Groups Discovery

**Estimated Cost:** ~$2-5/month (after free trial)

---

### 03 - Network Security Architecture
**Status:** 📋 Planned  
**Focus:** Secure VPC design and network segmentation

**Planned Implementation:**
- Multi-tier VPC architecture (public/private/isolated subnets)
- Security Groups with least privilege rules
- Network ACLs for subnet-level controls
- VPC Flow Logs for traffic analysis
- VPC Endpoints to avoid NAT gateway costs
- AWS Network Firewall (optional, cost consideration)

**Technologies:**
- Amazon VPC
- Security Groups & NACLs
- VPC Flow Logs
- VPC Endpoints
- AWS Systems Manager Session Manager (SSH alternative)
- Terraform modules

**Security Patterns:**
- Zero-trust network segmentation
- Bastion-less architecture with Session Manager
- Private subnet egress control
- Flow log analysis for anomaly detection

**Estimated Cost:** ~$3-8/month (Flow Logs storage, VPC Endpoints)

---

### 04 - Purple Team Cloud Scenarios
**Status:** 📋 Planned  
**Focus:** Cloud attack simulation and detection

**Planned Implementation:**
- Deploy vulnerable EC2 instances (t3.micro)
- Attack from home lab Kali Pi
- Simulate MITRE ATT&CK cloud techniques
- Build detection rules in GuardDuty/CloudWatch
- Document attack paths and defensive controls
- Create incident response playbooks

**Attack Scenarios:**
- Credential theft and lateral movement
- S3 bucket enumeration and exfiltration
- IAM privilege escalation
- Metadata service abuse (IMDSv1 vs v2)
- CloudTrail log tampering attempts

**Detection Development:**
- Custom EventBridge rules
- CloudWatch Insights queries
- GuardDuty finding analysis
- Automated response with Lambda

**Integration:**
- Extends home lab purple team methodology to cloud
- Demonstrates SOC analyst detection engineering skills
- Documents findings for blog content

**Estimated Cost:** ~$5-10/month (EC2 instances, limited runtime)

---

## Infrastructure as Code Approach

All AWS resources deployed via Terraform for:
- **Repeatability:** Consistent security baselines
- **Version Control:** Git-tracked infrastructure changes
- **Documentation:** Code as living documentation
- **Portfolio Value:** Demonstrates IaC proficiency

**Terraform Structure:**
```
aws/
├── 00-account-baseline/
│   └── (manual setup, documented)
├── 01-iam-security/
│   ├── terraform/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── modules/
│   └── docs/
└── shared-modules/
    ├── iam-roles/
    ├── security-groups/
    └── monitoring/
```

## Cost Management Strategy

**Free Tier Maximization:**
- 750 hours/month EC2 t2.micro/t3.micro (12 months)
- CloudTrail management events (ongoing)
- IAM unlimited (ongoing)
- CloudWatch Logs 5GB ingestion (ongoing)
- Limited AWS Config rules

**Cost Controls:**
- Budget alerts at $5, $8, $10
- Automated instance shutdown (Lambda)
- Tag-based cost tracking
- Regular AWS Cost Explorer reviews
- Spot instances for ephemeral workloads

**Monthly Budget Breakdown:**
- Account baseline: $0
- IAM security: $0
- Monitoring: $2-5
- Network security: $3-8
- Purple team labs: $5-10
- **Total Target:** $10-20/month

## Security Baseline Checklist

All labs build upon this foundational security baseline:

- ✅ Root account MFA enabled
- ✅ Root account unused (IAM admin instead)
- ✅ CloudTrail enabled (all regions)
- ✅ Billing alerts configured
- ✅ IAM password policy enforced
- ✅ MFA required for privileged users
- ✅ Access keys rotated regularly (90 days)
- ✅ IAM Access Analyzer enabled
- ✅ GuardDuty enabled
- ✅ Config rules for compliance (selective)
- ✅ Resource tagging strategy

## Compliance Frameworks

Labs map to relevant compliance controls:

**ISO27001:2022:**
- A.9.2 - User access management
- A.9.4 - System and application access control
- A.12.4 - Logging and monitoring
- A.13.1 - Network security management

**NIST Cybersecurity Framework:**
- ID.AM - Asset Management
- PR.AC - Identity Management and Access Control
- DE.AE - Security Continuous Monitoring
- DE.CM - Security Continuous Monitoring

**AWS Well-Architected Framework:**
- Security Pillar (all labs)
- Cost Optimization Pillar
- Operational Excellence Pillar

## Integration with Home Lab

AWS labs complement existing infrastructure:

**Home Lab (On-Premises):**
- Kali Linux (Raspberry Pi 4) - Attack platform
- Metasploitable 2 - Vulnerable targets
- Wazuh SIEM - Detection stack
- Unraid server - Infrastructure host

**Cloud Labs (AWS):**
- Extended attack surface for purple team
- Cloud-native threat detection
- Enterprise-scale security patterns
- Hybrid security monitoring (home lab + cloud)

**Cross-Environment Scenarios:**
- Attack AWS from home lab Kali
- Forward CloudTrail logs to Wazuh
- Correlate on-prem and cloud security events
- Document hybrid detection strategies

## Learning Objectives

By completing these labs, demonstrating capability to:

1. **Design** secure cloud architectures aligned with zero-trust principles
2. **Implement** IAM strategies for least privilege access
3. **Deploy** security monitoring and threat detection systems
4. **Automate** security controls using Infrastructure as Code
5. **Detect** cloud-specific attack techniques (MITRE ATT&CK)
6. **Respond** to security incidents in cloud environments
7. **Document** security implementations for compliance frameworks
8. **Optimize** security solutions for cost efficiency

## Next Steps

1. ✅ Complete account baseline security
2. 🚧 Build IAM security lab with Terraform
3. 📋 Enable GuardDuty and develop detection rules
4. 📋 Design secure VPC architecture
5. 📋 Execute purple team cloud scenarios
6. 📋 Document findings on gregqlewis.com

## Reference Documentation

- [AWS Security Best Practices](https://docs.aws.amazon.com/security/)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [MITRE ATT&CK for Cloud](https://attack.mitre.org/matrices/enterprise/cloud/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

**Last Updated:** January 2026  
**Account:** greg-cloudsec-lab  
**Region:** us-east-1