##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

resource "aws_kinesis_stream" "default" {
  name                      = var.stream_name
  shard_count               = var.stream_mode != "ON_DEMAND" ? var.shard_count : null
  retention_period          = var.retention_period
  shard_level_metrics       = var.shard_level_metrics
  enforce_consumer_deletion = var.enforce_consumer_deletion
  encryption_type           = var.encryption_type
  kms_key_id                = var.kms_key_id

  # Dynamically configure stream mode if provided
  dynamic "stream_mode_details" {
    for_each = var.stream_mode != null ? ["true"] : []
    content {
      stream_mode = var.stream_mode
    }
  }

  tags = var.tags
}

resource "aws_kinesis_stream_consumer" "default" {
  count = var.consumer_enabled ? var.consumer_count : 0

  name       = format("%s-consumer-%s", var.stream_name, count.index)
  stream_arn = aws_kinesis_stream.default.arn
}

