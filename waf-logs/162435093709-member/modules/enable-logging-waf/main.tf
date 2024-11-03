##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################


resource "aws_wafv2_web_acl_logging_configuration" "logging" {
  count = length(var.waf_arn)

  resource_arn = element(var.waf_arn, count.index)

  # All WebACLs send logs to the same CloudWatch log group
  log_destination_configs = [
    var.log_group_arn 
  ]

}
