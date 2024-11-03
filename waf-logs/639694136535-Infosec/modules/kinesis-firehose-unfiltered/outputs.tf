##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

output "stream_arn" {
  description = "The ARN of the Kinesis Firehose delivery stream"
  value       = aws_kinesis_firehose_delivery_stream.kinesis_to_s3_unfiltered.arn
}

output "firehose_role_arn" {
  description = "The ARN of the IAM role used by Kinesis Firehose"
  value       = aws_iam_role.unfiltered_firehose.arn
}

