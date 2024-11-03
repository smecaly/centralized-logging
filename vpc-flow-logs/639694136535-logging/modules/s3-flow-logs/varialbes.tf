##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "tags" {
  description = "Tags for the S3 bucket"
  type        = map(string)
  default     = {}
}

variable "versioning_enabled" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = false
}

variable "lifecycle_enabled" {
  description = "Enable lifecycle configuration for the S3 bucket"
  type        = bool
  default     = false
}

variable "expiration_days" {
  description = "Number of days after which objects expire"
  type        = number
  default     = 365
}

variable "source_account_ids" {
  description = "List of AWS account IDs allowed to access the bucket"
  type        = list(string)
}

