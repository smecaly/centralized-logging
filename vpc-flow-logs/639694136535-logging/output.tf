##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

# Outputs for S3 bucket details from the flow_logs_s3_bucket module

output "flow_logs_bucket_name" {
  description = "The name of the created S3 bucket for flow logs"
  value       = module.flow_logs_s3_bucket.bucket_name
}

output "flow_logs_bucket_arn" {
  description = "The ARN of the created S3 bucket for flow logs"
  value       = module.flow_logs_s3_bucket.bucket_arn
}

output "flow_logs_bucket_policy_id" {
  description = "The ID of the policy applied to the S3 bucket for flow logs"
  value       = module.flow_logs_s3_bucket.bucket_policy
}
