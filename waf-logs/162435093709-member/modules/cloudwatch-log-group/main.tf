##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

resource "aws_cloudwatch_log_group" "waf_log_group" {
  name              = var.waf_log_group_name
  retention_in_days = var.retention_in_days
}

resource "aws_cloudwatch_log_subscription_filter" "kinesis_subscription_filters" {
  for_each         = { for idx, name in var.filter_names : idx => name }
  name             = each.value
  log_group_name   = aws_cloudwatch_log_group.waf_log_group.name
  filter_pattern   = var.filter_patterns[each.key]
  destination_arn  = var.destination_arns[each.key]
  distribution     = "ByLogStream"
}

