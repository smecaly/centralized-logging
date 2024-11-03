##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

# ------------------------ CloudWatch Logs Destination Outputs ------------------------

output "cloudwatch_logs_destination_filtered_arn" {
  description = "The ARN of the filtered CloudWatch Logs destination."
  value       = module.cloudwatch_logs_destination_filtered.destination_arn
}

output "cloudwatch_logs_destination_unfiltered_arn" {
  description = "The ARN of the unfiltered CloudWatch Logs destination."
  value       = module.cloudwatch_logs_destination_unfiltered.destination_arn
}

