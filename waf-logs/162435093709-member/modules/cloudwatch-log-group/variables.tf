##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

variable "waf_log_group_name" {
  description = "The name of the CloudWatch Log Group"
  type        = string
}

variable "retention_in_days" {
  description = "Retention period for CloudWatch Log Group"
  type        = number
}

variable "filter_names" {
  description = "List of names for the CloudWatch log subscription filters"
  type        = list(string)
}

variable "filter_patterns" {
  description = "List of filter patterns for each subscription filter"
  type        = list(string)
}

variable "destination_arns" {
  description = "List of destination ARNs for each subscription filter"
  type        = list(string)
}

