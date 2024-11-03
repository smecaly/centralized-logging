##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

variable "waf_arn" {
  description = "List of WAF WebACL ARNs to enable logging for."
  type        = list(string)
  default = []
}

variable "log_group_arn" {
  description = "The ARN of the CloudWatch log group where WAF logs should be sent."
  type        = string
}
