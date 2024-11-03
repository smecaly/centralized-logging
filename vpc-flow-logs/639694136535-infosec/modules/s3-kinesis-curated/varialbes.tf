##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

variable "bucket_name" {
  description = "The name of the S3 bucket to be created."
  type        = string
}

variable "versioning_enabled" {
  description = "Enable versioning for the S3 bucket."
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "The server-side encryption algorithm to use for bucket objects. Valid values are 'AES256' or 'aws:kms'."
  type        = string
  default     = "AES256"
}

variable "kms_key_id" {
  description = "The KMS key ID to use for encryption when 'aws:kms' is chosen."
  type        = string
  default     = null
}

variable "lifecycle_enabled" {
  description = "Enable lifecycle rules for object expiration."
  type        = bool
  default     = false
}

variable "expiration_days" {
  description = "The number of days after which objects are automatically deleted."
  type        = number
  default     = 365
}

variable "tags" {
  description = "A map of tags to assign to the S3 bucket."
  type        = map(string)
  default     = {
    Owner = "terraform"
  }
}

variable "kms_master_key_id" {
  description = "The KMS key ID to use for encrypting the S3 bucket"
  type        = string
}

variable "destination_account_id" {
  description = "Destination account ID for CloudWatch logs"
  type        = string
}

variable "firehose_role_arn" {
  type = string
}
