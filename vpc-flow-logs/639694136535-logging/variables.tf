##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

# ------------------------ S3 Bucket Module Variables ------------------------
variable "bucket_name" {
  description = "The name of the S3 bucket for flow logs"
  type        = string
}

variable "tags" {
  description = "Tags for the S3 bucket"
  type        = map(string)
  default     = {
    Environment = "Production"
    Project     = "Centralized Logging"
  }
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
  description = "Number of days after which objects in the S3 bucket expire"
  type        = number
  default     = 365
}

# ------------------------ Glue Crawler Module Variables ------------------------
variable "database_name_unfiltered" {
  description = "Name of the Glue database for unfiltered WAF logs"
  type        = string
}

variable "crawler_name" {
  description = "Name of the Glue crawler"
  type        = string
}

variable "schedule_unfiltered" {
  description = "Schedule for the unfiltered Glue crawler"
  type        = string
}

variable "prefix" {
  description = "Prefix for resources created by the module"
  type        = string
}

variable "crawler_description" {
  description = "Description for the Glue crawler"
  type        = string
}

variable "configuration_unfiltered" {
  description = "Configuration for the unfiltered Glue crawler"
  type        = string
}

# ------------------------ Athena Module Variables ------------------------
variable "athena_workgroup_name" {
  description = "Name of the Athena workgroup"
  type        = string
}

variable "s3_output_location" {
  description = "S3 location for Athena query results"
  type        = string
}

variable "athena_enforce_workgroup_configuration" {
  description = "Whether to enforce workgroup configuration for Athena"
  type        = bool
  default     = false
}

variable "athena_prefix" {
  description = "Prefix for Athena resources"
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key for encryption"
  type        = string
}

variable "source_account_ids" {
  description = "List of AWS account IDs allowed to access the bucket"
  type        = list(string)
}
