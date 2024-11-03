##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

resource "aws_cloudwatch_log_group" "waf_log_group" {

  name = "/aws/lambda/${var.function_name}"

  retention_in_days = var.retention_in_days
}

resource "aws_cloudwatch_log_group" "firehose_log_group" {
  name = "/aws/kinesisfirehose/${var.filtered_firehose_name}-delivery"
  tags = var.tags
}

resource "aws_cloudwatch_log_stream" "firehose_log_stream" {
  name           = "/aws/kinesisfirehose/${var.filtered_firehose_name}}-stream"
  log_group_name = aws_cloudwatch_log_group.firehose_log_group.name
}
