##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

variable "bucket_name" {
  description = "Name of the S3 bucket for storing WAF logs"
  type        = string
}

variable "versioning_enabled" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm for the S3 bucket (e.g., AES256 or aws:kms)"
  type        = string
  default     = "aws:kms"
}

variable "kms_master_key_id" {
  description = "KMS key ID for encrypting objects in the S3 bucket, if using aws:kms"
  type        = string
  default     = null
}

variable "lifecycle_enabled" {
  description = "Enable lifecycle policy for automatic object expiration in the S3 bucket"
  type        = bool

}

variable "expiration_days" {
  description = "Number of days after which objects in the S3 bucket should expire"
  type        = number

}

variable "kinesis_firehose_role_arn" {
  description = "ARN of the IAM role used by Kinesis Firehose in the Infosec account for access to the S3 bucket"
  type        = string
}

variable "logging_account_id" {
  description = "Account ID of the logging account where the S3 bucket resides, granting read access"
  type        = string
}

variable "infosec_account_id" {
  description = "Account ID of the logging account where the S3 bucket resides, granting read access"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the S3 bucket and associated resources"
  type        = map(string)
  default     = {}
}
