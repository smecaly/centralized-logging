##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

output "waf_logs_bucket_name" {
  description = "The name of the S3 bucket for storing unfiltered WAF logs"
  value       = module.s3_unfiltered_waf_logs.bucket_name
}

