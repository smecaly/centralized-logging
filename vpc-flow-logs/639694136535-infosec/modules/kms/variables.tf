##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

variable "description" {
  description = "The description of the KMS key"
  type        = string
  default     = "KMS key for encrypting resources"
}

variable "deletion_window_in_days" {
  description = "The waiting period before the key is deleted"
  type        = number
  default     = 10
}

variable "enable_key_rotation" {
  description = "Specifies whether key rotation is enabled"
  type        = bool
  default     = true
}

variable "alias_name" {
  description = "Alias name for the KMS key"
  type        = string
  default     = "my-kms-key"
}

variable "firehose_arn" {
  type = string
}

variable "tags" {
  description = "Tags to assign to the KMS key"
  type        = map(string)
  default     = {}
}
