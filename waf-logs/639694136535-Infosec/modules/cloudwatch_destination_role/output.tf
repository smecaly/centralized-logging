##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

output "cloudwatch_kinesis_role_arn" {
  description = "The ARN of the IAM role for CloudWatch Kinesis access."
  value       = aws_iam_role.cloudwatch_kinesis_role.arn
}

output "cloudwatch_kinesis_role_name" {
  description = "The name of the IAM role for CloudWatch Kinesis access."
  value       = aws_iam_role.cloudwatch_kinesis_role.name
}

output "cloudwatch_kinesis_policy_arn" {
  description = "The ARN of the IAM policy attached to the CloudWatch Kinesis role."
  value       = aws_iam_policy.cloudwatch_kinesis_policy.arn
}

output "cloudwatch_kinesis_policy_name" {
  description = "The name of the IAM policy attached to the CloudWatch Kinesis role."
  value       = aws_iam_policy.cloudwatch_kinesis_policy.name
}
