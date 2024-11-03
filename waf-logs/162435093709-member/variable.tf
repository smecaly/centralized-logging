##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

# ------------------------ CloudWatch Log Group Module Variables ------------------------

variable "waf_log_group_name" {
  description = "The name of the CloudWatch Log Group for WAF logs."
  type        = string
}

variable "retention_in_days" {
  description = "Retention period (in days) for the CloudWatch Log Group."
  type        = number
  default     = 14
}

variable "filter_names" {
  description = "List of names for the CloudWatch log subscription filters."
  type        = list(string)
}

variable "filter_patterns" {
  description = "List of filter patterns for each subscription filter. Each filter pattern applies to the respective filter name."
  type        = list(string)
}

variable "destination_arns" {
  description = "List of destination ARNs for each subscription filter, corresponding to filter names."
  type        = list(string)
}

# ------------------------ WAF Logging Module Variables ------------------------

variable "waf_arn" {
  description = "List of WAF ARNs to enable logging."
  type        = list(string)
}
