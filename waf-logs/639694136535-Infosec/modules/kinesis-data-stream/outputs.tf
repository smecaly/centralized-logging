##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

output "kinesis_stream_arn" {
  description = "ARN of the Kinesis Data Stream"
  value       = aws_kinesis_stream.default.arn
}

output "kinesis_stream_name" {
  description = "Name of the Kinesis Data Stream"
  value       = aws_kinesis_stream.default.name
}

output "kinesis_stream_consumers" {
  description = "Names of the Kinesis Stream Consumers"
  value       = [for consumer in aws_kinesis_stream_consumer.default : consumer.name]
}

