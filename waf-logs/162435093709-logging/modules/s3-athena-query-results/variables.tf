##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

variable "bucket_name" {
  description = "The name of the S3 bucket for Athena query results"
  type        = string
}

variable "enable_versioning" {
  description = "Enable versioning on the S3 bucket"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to apply to the S3 bucket"
  type        = map(string)
  default     = {
    Owner = "terraform"
  }
}


variable "expiration_days" {
  description = "Number of days after which objects expire"
  type        = number
  default     = 90 
}

variable "sse_algorithm" {
  description = "S3 Server-Side Encryption algorithm"
  type        = string
}

variable "kms_master_key_id" {
  description = "The KMS key ID to use for encrypting the S3 bucket"
  type        = string
}

variable "lifecycle_enabled" {
  description = "Enable or disable lifecycle rules."
  type        = bool
}