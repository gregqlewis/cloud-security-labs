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

output "security_auditor_role_arn" {
  description = "ARN of the security auditor role"
  value       = aws_iam_role.security_auditor.arn
}

output "security_auditor_role_name" {
  description = "Name of the security auditor role"
  value       = aws_iam_role.security_auditor.name
}

output "assume_role_command" {
  description = "AWS CLI command to assume the security auditor role (requires MFA)"
  value       = "aws sts assume-role --role-arn ${aws_iam_role.security_auditor.arn} --role-session-name security-audit-session --serial-number <YOUR_MFA_ARN> --token-code <MFA_CODE> --profile cloudsec-lab"
}
