##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

resource "aws_kinesis_firehose_delivery_stream" "kinesis_to_s3_unfiltered" {
  name        = var.unfiltered_firehose_name
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.unfiltered_firehose.arn
    bucket_arn = var.unfiltered_bucket_arn

    prefix     = "raw/"  

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.firehose_log_group.name
      log_stream_name = aws_cloudwatch_log_stream.firehose_log_stream.name
    }
  }

  tags = var.tags
}
