##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

output "bucket_arn" {
  description = "The ARN of the S3 bucket."
  value       = aws_s3_bucket.waf_logs_bucket.arn
}

output "bucket_name" {
  description = "The name of the S3 bucket."
  value       = aws_s3_bucket.waf_logs_bucket.id
}
