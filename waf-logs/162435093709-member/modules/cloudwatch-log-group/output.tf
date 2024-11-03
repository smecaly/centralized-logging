##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

output "waf_log_group_name" {
  description = "The name of the WAF log group."
  value       = aws_cloudwatch_log_group.waf_log_group.name
}

output "waf_log_group_arn" {
  description = "The ARN of the WAF CloudWatch log group."
  value       = aws_cloudwatch_log_group.waf_log_group.arn
}
