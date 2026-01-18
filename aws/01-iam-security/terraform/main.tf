# ============================================================================
# IAM Security Lab - Phase 1: Custom Policies
# ============================================================================

# Data source to get current AWS account information
data "aws_caller_identity" "current" {}

# Data source to get current region
data "aws_region" "current" {}

# ============================================================================
# IAM Access Analyzer - Detect overly permissive policies
# ============================================================================

resource "aws_accessanalyzer_analyzer" "security_analyzer" {
  analyzer_name = "${var.project_name}-access-analyzer"
  type          = "ACCOUNT"

  tags = {
    Name        = "${var.project_name}-access-analyzer"
    Description = "Detects resources shared with external entities"
  }
}

# ============================================================================
# Custom IAM Policy: Security Auditor (Read-Only)
# ============================================================================

data "aws_iam_policy_document" "security_auditor" {
  # CloudTrail read access
  statement {
    sid    = "CloudTrailReadAccess"
    effect = "Allow"
    actions = [
      "cloudtrail:DescribeTrails",
      "cloudtrail:GetTrailStatus",
      "cloudtrail:LookupEvents",
      "cloudtrail:ListTags",
      "cloudtrail:GetEventSelectors",
      "cloudtrail:GetInsightSelectors"
    ]
    resources = ["*"]
  }

  # GuardDuty read access (for when we enable it)
  statement {
    sid    = "GuardDutyReadAccess"
    effect = "Allow"
    actions = [
      "guardduty:Get*",
      "guardduty:List*",
      "guardduty:Describe*"
    ]
    resources = ["*"]
  }

  # IAM read access
  statement {
    sid    = "IAMReadAccess"
    effect = "Allow"
    actions = [
      "iam:Get*",
      "iam:List*",
      "iam:Generate*"
    ]
    resources = ["*"]
  }

  # Access Analyzer read access
  statement {
    sid    = "AccessAnalyzerReadAccess"
    effect = "Allow"
    actions = [
      "access-analyzer:Get*",
      "access-analyzer:List*"
    ]
    resources = ["*"]
  }

  # CloudWatch Logs read access (for security event investigation)
  statement {
    sid    = "CloudWatchLogsReadAccess"
    effect = "Allow"
    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
    ]
    resources = ["*"]
  }

  # S3 read access for CloudTrail logs
  statement {
    sid    = "S3ReadAccessForLogs"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::aws-cloudtrail-logs-*",
      "arn:aws:s3:::aws-cloudtrail-logs-*/*"
    ]
  }

  # Deny critical security modifications
  statement {
    sid    = "DenySecurityModifications"
    effect = "Deny"
    actions = [
      "iam:CreateUser",
      "iam:DeleteUser",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:PutUserPolicy",
      "iam:PutRolePolicy",
      "iam:AttachUserPolicy",
      "iam:AttachRolePolicy",
      "cloudtrail:StopLogging",
      "cloudtrail:DeleteTrail",
      "guardduty:DeleteDetector"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "security_auditor" {
  name        = "${var.project_name}-security-auditor-policy"
  description = "Read-only access to security services for auditing and compliance reviews"
  policy      = data.aws_iam_policy_document.security_auditor.json

  tags = {
    Name        = "${var.project_name}-security-auditor-policy"
    Description = "Custom least privilege policy for security auditors"
    Compliance  = "ISO27001-A.9.4.1"
  }
}

# ============================================================================
# IAM Role: Security Auditor (uses the custom policy above)
# ============================================================================

# Trust policy - who can assume this role
data "aws_iam_policy_document" "security_auditor_assume_role" {
  statement {
    sid     = "AllowAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

resource "aws_iam_role" "security_auditor" {
  name               = "${var.project_name}-security-auditor-role"
  description        = "Security auditor role with read-only access to security services, requires MFA"
  assume_role_policy = data.aws_iam_policy_document.security_auditor_assume_role.json

  tags = {
    Name        = "${var.project_name}-security-auditor-role"
    Description = "Read-only security auditing role"
    MFARequired = "true"
  }
}

# Attach our custom policy to the role
resource "aws_iam_role_policy_attachment" "security_auditor_custom" {
  role       = aws_iam_role.security_auditor.name
  policy_arn = aws_iam_policy.security_auditor.arn
}

# Also attach AWS managed SecurityAudit policy for additional read permissions
resource "aws_iam_role_policy_attachment" "security_auditor_aws_managed" {
  role       = aws_iam_role.security_auditor.name
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

# ============================================================================
# Outputs
# ============================================================================

output "security_auditor_policy_arn" {
  description = "ARN of the security auditor IAM policy"
  value       = aws_iam_policy.security_auditor.arn
}

output "access_analyzer_arn" {
  description = "ARN of the IAM Access Analyzer"
  value       = aws_accessanalyzer_analyzer.security_analyzer.arn
}
