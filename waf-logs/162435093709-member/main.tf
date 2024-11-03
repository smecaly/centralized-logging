##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

# Module to create a CloudWatch log group for WAF with specified retention and multiple subscription filters
module "cloudwatch_log_group_waf" {
  source            = "./modules/cloudwatch-log-group"
  waf_log_group_name = var.waf_log_group_name
  retention_in_days  = var.retention_in_days
  filter_names       = var.filter_names
  filter_patterns    = var.filter_patterns
  destination_arns   = var.destination_arns
}

# Module to enable WAF logging and associate it with the specified CloudWatch log group
module "enable_waf_logging" {
  source        = "./modules/enable-logging-waf"
  waf_arn       = var.waf_arn
  log_group_arn = module.cloudwatch_log_group_waf.waf_log_group_arn  # Reference the log group ARN output
}
