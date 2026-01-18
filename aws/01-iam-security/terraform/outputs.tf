output "account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "region" {
  description = "AWS Region"
  value       = data.aws_region.current.name
}

output "access_analyzer_id" {
  description = "IAM Access Analyzer ID"
  value       = aws_accessanalyzer_analyzer.security_analyzer.id
}

output "security_auditor_policy_name" {
  description = "Name of the security auditor policy"
  value       = aws_iam_policy.security_auditor.name
}
