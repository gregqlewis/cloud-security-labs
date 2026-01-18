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

| Lab                                               | Focus Area                     | Status        | Key Technologies                   |
| ------------------------------------------------- | ------------------------------ | ------------- | ---------------------------------- |
| [00 - Account Baseline](aws/00-account-baseline/) | Initial security configuration | ✅ Complete    | CloudTrail, IAM, Billing           |
| [01 - IAM Security](aws/01-iam-security/)         | Identity and access management | 🚧 In Progress | IAM, Access Analyzer, Terraform    |
| 02 - Security Monitoring                          | SIEM and detection             | 📋 Planned     | GuardDuty, EventBridge, CloudWatch |
| 03 - Network Security                             | VPC security architecture      | 📋 Planned     | VPC, Security Groups, Flow Logs    |
| 04 - Purple Team Scenarios                        | Cloud attack/defense           | 📋 Planned     | MITRE ATT&CK, Detection Rules      |

### Azure Security Labs

| Lab                                         | Focus Area          | Status    | Key Technologies                   |
| ------------------------------------------- | ------------------- | --------- | ---------------------------------- |
| [01 - IAM Security](azure/01-iam-security/) | Azure AD and RBAC   | 📋 Planned | Azure AD, PIM, Conditional Access  |
| 02 - Sentinel SIEM                          | Security monitoring | 📋 Planned | Microsoft Sentinel, KQL, Workbooks |

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
- 4+ years cybersecurity experience supporting federal defense contracts
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
├── aws/                          # AWS security labs
│   ├── 00-account-baseline/      # Initial security setup
│   ├── 01-iam-security/          # IAM deep dive
│   └── README.md                 # AWS-specific overview
├── azure/                        # Azure security labs
│   ├── 01-iam-security/          # Azure AD implementation
│   └── README.md                 # Azure-specific overview
├── docs/                         # Cross-cutting documentation
│   ├── multi-cloud-comparison.md
│   └── cost-optimization.md
└── README.md                     # This file
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

**Last Updated:** January 2026