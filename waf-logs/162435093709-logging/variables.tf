##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

# ------------------------ KMS Encryption Module Variables ------------------------
variable "kms_description" {
  description = "Description for the KMS key used in the encryption module"
  type        = string
}

variable "kms_alias_name" {
  description = "Alias name for the KMS key"
  type        = string
}

variable "kms_deletion_window" {
  description = "Number of days before KMS key deletion"
  type        = number
}

variable "kms_enable_rotation" {
  description = "Whether to enable key rotation for KMS"
  type        = bool
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

# ------------------------ S3 Unfiltered WAF Logs Module Variables ------------------------
variable "waf_logs_bucket_name" {
  description = "Name of the S3 bucket for unfiltered WAF logs"
  type        = string
}

variable "versioning_enabled" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
}

# variable "sse_algorithm" {
#   description = "Server-side encryption algorithm for S3 bucket"
#   type        = string
#   default     = "aws:kms"
# }

variable "lifecycle_enabled" {
  description = "Enable lifecycle policies for the S3 bucket"
  type        = bool
}

variable "expiration_days" {
  description = "Number of days before objects in the S3 bucket expire"
  type        = number
}

variable "kinesis_firehose_role_arn" {
  description = "ARN of the Kinesis Firehose IAM role with access to the S3 bucket"
  type        = string
}

variable "logging_account_id" {
  description = "ID of the AWS account with logging access"
  type        = string
}

variable "infosec_account_id" {
  description = "ID of the Infosec AWS account for access control"
  type        = string
}

# ------------------------ Glue Crawler Module Variables ------------------------

variable "database_name_unfiltered" {
  description = "The name of the Glue catalog database for unfiltered logs."
  type        = string
}

variable "crawler_name" {
  description = "The base name for the Glue crawler."
  type        = string
}

variable "schedule_unfiltered" {
  description = "The cron expression for scheduling the unfiltered Glue crawler."
  type        = string
  default     = ""
}

variable "prefix" {
  description = "Prefix for Glue and related resource names."
  type        = string
}

variable "crawler_description" {
  description = "The description for the Glue crawler."
  type        = string
}

variable "configuration_unfiltered" {
  description = "Glue crawler configuration in JSON format for unfiltered logs."
  type        = string
  default     = ""
}


# ------------------------ Athena Module Variables ------------------------
variable "athena_workgroup_name" {
  description = "Name of the Athena workgroup"
  type        = string
}

variable "s3_output_location" {
  description = "S3 output location for Athena query results"
  type        = string
}

variable "athena_enforce_workgroup_configuration" {
  description = "Enforce Athena workgroup configuration settings"
  type        = bool
}

variable "athena_prefix" {
  description = "Prefix for Athena resources"
  type        = string
}

# ------------------------ Athena S3 Query Results Bucket Module Variables ------------------------
variable "athena_s3_results_bucket_name" {
  description = "Name of the S3 bucket for Athena query results"
  type        = string
}

variable "athena_enable_versioning" {
  description = "Enable versioning for Athena S3 results bucket"
  type        = bool
}
