##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

output "cloudwatch_log_destination_arn" {
  description = "The ARN of the CloudWatch Logs destination"
  value       = aws_cloudwatch_log_destination.destination.arn
}
