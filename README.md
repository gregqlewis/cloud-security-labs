# Cloud Security Labs

A hands-on portfolio demonstrating cloud security engineering capabilities across AWS and Azure, with emphasis on Identity & Access Management, security monitoring, Infrastructure as Code, and purple team methodologies.

## About

This repository documents my transition from SOC operations to Cloud Security Engineering, showcasing practical implementations of security controls, threat detection, and compliance frameworks in cloud environments.

**Author:** Greg Lewis  
**Current Role:** SOC Analyst  
**Target Role:** Cloud Security Engineer  
**Education:** M.S. Cybersecurity Technology - UMGC  
**Certifications:** Security+ CE  
**Website:** [gregqlewis.com](https://gregqlewis.com)

## Portfolio Objectives

- Demonstrate multi-cloud security expertise (AWS, Azure)
- Build security controls using Infrastructure as Code (Terraform)
- Apply purple team methodology to cloud attack/defense scenarios
- Document security implementations aligned with compliance frameworks (ISO27001, NIST)
- Create reusable security patterns for enterprise environments

## Labs Overview

### AWS Security Labs

| Lab                                               | Focus Area                     | Status     | Key Technologies                   |
| ------------------------------------------------- | ------------------------------ | ---------- | ---------------------------------- |
| [00 - Account Baseline](aws/00-account-baseline/) | Initial security configuration | ✅ Complete | CloudTrail, IAM, Billing           |
| [01 - IAM Security](aws/01-iam-security/)         | Identity and access management | ✅ Complete | IAM, Access Analyzer, Terraform    |
| 02 - Security Monitoring                          | SIEM and detection             | 📋 Planned  | GuardDuty, EventBridge, CloudWatch |
| 03 - Network Security                             | VPC security architecture      | 📋 Planned  | VPC, Security Groups, Flow Logs    |
| 04 - Purple Team Scenarios                        | Cloud attack/defense           | 📋 Planned  | MITRE ATT&CK, Detection Rules      |

### Azure Security Labs

| Lab                                                 | Focus Area                     | Status     | Key Technologies                          |
| --------------------------------------------------- | ------------------------------ | ---------- | ----------------------------------------- |
| [00 - Account Baseline](azure/00-account-baseline/) | Initial security configuration | ✅ Complete | Activity Logs, Service Principal, Budgets |
| [01 - IAM Security](azure/01-iam-security/)         | Azure AD and RBAC              | ✅ Complete | Azure AD, RBAC, Terraform                 |
| 02 - Sentinel SIEM                                  | Security monitoring            | 📋 Planned  | Microsoft Sentinel, KQL, Workbooks        |
| 03 - Network Security                               | VNet security architecture     | 📋 Planned  | VNet, NSGs, Azure Firewall                |
| 04 - Purple Team Scenarios                          | Cloud attack/defense           | 📋 Planned  | MITRE ATT&CK, Detection Rules             |

### Cross-Platform Documentation

| Document                                                           | Status     | Description                                            |
| ------------------------------------------------------------------ | ---------- | ------------------------------------------------------ |
| [AWS vs Azure IAM Comparison](docs/aws-vs-azure-iam-comparison.md) | ✅ Complete | Architecture, terminology, and implementation patterns |

## Recent Progress

**January 18, 2026:**
- ✅ Established secure account baselines in both AWS and Azure
- ✅ Deployed custom least-privilege IAM policies using Terraform
- ✅ Created Security Auditor role with MFA enforcement (AWS)
- ✅ Built custom RBAC Security Auditor role (Azure)
- ✅ Enabled IAM Access Analyzer for privilege detection
- ✅ Tested role assumption and verified permission controls
- ✅ Documented comprehensive AWS vs Azure IAM comparison
- ✅ Implemented Infrastructure as Code for all resources

**Key Achievements:**
- First production Terraform deployments in both cloud platforms
- Working IAM implementations with least privilege design
- Professional documentation with compliance mappings (ISO27001, NIST)
- Portfolio demonstrates multi-cloud security engineering capability

**Next Steps:**
- Enable GuardDuty and Microsoft Sentinel for security monitoring
- Build privilege escalation detection scenarios
- Create additional custom roles (EC2 Operator, Lambda Developer)
- Publish first blog post on gregqlewis.com

## Technical Stack

**Cloud Platforms:**
- AWS (Primary focus for federal market alignment)
- Microsoft Azure

**Infrastructure as Code:**
- Terraform
- Version control via Git/GitHub

**Security Tools:**
- AWS: CloudTrail, GuardDuty, IAM Access Analyzer, Config
- Azure: Sentinel, Defender for Cloud, Azure AD
- Detection: Custom rules, MITRE ATT&CK mappings

**Purple Team Integration:**
- Attack simulations from home lab environment
- Kali Linux on Raspberry Pi 4
- Detection rule development and testing
- Integration with existing Wazuh SIEM

## Lab Standards

Each lab includes:
- **README.md** - Objectives, architecture, and findings
- **Terraform configurations** - Infrastructure as Code implementations
- **Documentation** - Setup guides, attack scenarios, detection strategies
- **Architecture diagrams** - Visual representation of implementations
- **Lessons learned** - Key takeaways and real-world applications
- **Cost analysis** - Budget optimization strategies
- **Compliance mappings** - NIST, ISO27001 framework alignment

## Cost Management

All labs designed for minimal cost using:
- AWS Free Tier (12 months)
- Azure for Students ($100 credit)
- Automated resource shutdown
- Budget alerts and monitoring
- Cost optimization documentation

Target monthly spend: $0-10

## Professional Context

This portfolio bridges my experience as a SOC Analyst with hands-on cloud security engineering skills:

**Current Expertise:**
- 4+ years cybersecurity experience supporting federal contracts
- Threat hunting and incident response in AWS environments
- Enterprise security tools: Splunk, CrowdStrike, Tenable, Zscaler
- ISO27001:2022 compliance leadership

**Building Towards:**
- Cloud Security Engineer roles in DMV federal market
- Multi-cloud IAM and security architecture
- Infrastructure as Code with security controls
- Purple team cloud methodologies

## Repository Structure
```
cloud-security-labs/
├── README.md                     # Portfolio overview (this file)
├── docs/                         # Cross-cutting documentation
│   └── aws-vs-azure-iam-comparison.md  # ✅ Multi-cloud IAM analysis
├── aws/                          # AWS security labs
│   ├── README.md                 # ✅ AWS-specific overview
│   ├── 00-account-baseline/      # ✅ Initial security setup
│   │   └── README.md
│   ├── 01-iam-security/          # ✅ IAM deep dive
│   │   ├── README.md
│   │   ├── terraform/            # ✅ Working Terraform code
│   │   ├── policies/
│   │   ├── docs/
│   │   └── screenshots/          # ✅ Documentation screenshots
│   ├── 02-security-monitoring/   # 📋 Planned
│   ├── 03-network-security/      # 📋 Planned
│   └── 04-purple-team/           # 📋 Planned
└── azure/                        # Azure security labs
    ├── README.md                 # ✅ Azure-specific overview
    ├── 00-account-baseline/      # ✅ Initial security setup
    │   └── README.md
    ├── 01-iam-security/          # ✅ Azure AD & RBAC
    │   ├── README.md
    │   ├── terraform/            # ✅ Working Terraform code
    │   ├── roles/
    │   ├── docs/
    │   └── screenshots/          # ✅ Documentation screenshots
    ├── 02-sentinel-monitoring/   # 📋 Planned
    ├── 03-network-security/      # 📋 Planned
    └── 04-purple-team/           # 📋 Planned
```

## Getting Started

Each lab directory contains detailed setup instructions. General prerequisites:
```bash
# AWS CLI
aws --version
aws configure --profile cloudsec-lab

# Azure CLI
az --version
az login

# Terraform
terraform --version

# Clone repository
git clone https://github.com/YOUR-USERNAME/cloud-security-labs.git
cd cloud-security-labs
```

## Integration with Home Lab

These cloud labs complement my existing purple team home lab infrastructure:
- **Attack Platform:** Kali Linux on Raspberry Pi 4
- **Vulnerable Targets:** Metasploitable 2
- **Detection Stack:** Wazuh SIEM, Graylog, OpenSearch
- **Infrastructure:** Unraid server with Docker containers

Cloud labs extend purple team methodology to AWS/Azure environments, documenting detection strategies applicable to enterprise SOC operations.

## Blog Integration

Detailed writeups and lessons learned published at [gregqlewis.com](https://gregqlewis.com), integrating technical expertise with Christian values and professional development journey.

## Contact

**Greg Lewis**  
- Website: [gregqlewis.com](https://gregqlewis.com)
- LinkedIn: [@gregqlewis](www.linkedin.com/in/gregqlewis)
- GitHub: [@gregqlewis](https://github.com/gregqlewis)
- Location: DMV area

---

*Building in public - documenting my transition from SOC operations to Cloud Security Engineering*

**Last Updated:** February 2026
