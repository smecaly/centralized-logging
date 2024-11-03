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

# ------------------------ CloudWatch Logs Destination Role Module Variables ------------------------

variable "source_account_ids" {
  description = "List of source account IDs for CloudWatch Logs destination"
  type        = list(string)
}

variable "destination_account_id" {
  description = "Destination account ID for CloudWatch Logs destination"
  type        = string
}

variable "prefix" {
  description = "Prefix for naming IAM resources (role and policy) for CloudWatch Kinesis access."
  type        = string
}



variable "region" {
  description = "AWS region where resources will be created"
  type        = string
}

# ------------------------ CloudWatch Logs Destination Module Variables ------------------------

variable "cloudwatch_destination_name_filtered" {
  description = "Name of the CloudWatch Logs destination"
  type        = string
}

# unfiltered


variable "cloudwatch_destination_name_unfiltered" {
  description = "Name of the CloudWatch Logs destination"
  type        = string
}


# ------------------------ Kinesis Firehose (Filtered) Module Variables ------------------------

variable "filtered_firehose_name" {
  description = "Name of the Kinesis Firehose delivery stream (filtered)"
  type        = string
}

variable "iam_name_prefix" {
  description = "IAM name prefix for Kinesis Firehose"
  type        = string
}

# ------------------------ Kinesis Firehose (Unfiltered) Module Variables ------------------------

variable "kinesis_firehose_unfiltered_name" {
  description = "Name of the Kinesis Firehose delivery stream (unfiltered)"
  type        = string
}

variable "unfiltered_bucket_arn" {
  description = "ARN of the S3 bucket for unfiltered Firehose logs"
  type        = string
}

# ------------------------ Kinesis Firehose S3 Logs Module Variables ------------------------

variable "kinesis_s3_bucket_name" {
  description = "Name of the S3 bucket for Kinesis Firehose logs"
  type        = string
}

variable "kinesis_s3_versioning_enabled" {
  description = "Enable versioning for Kinesis Firehose S3 bucket"
  type        = bool
}

variable "lifecycle_enabled" {
  description = "Enable lifecycle policies for the S3 bucket"
  type        = bool
}

variable "expiration_days" {
  description = "Number of days before objects in the S3 bucket expire"
  type        = number
}

# ------------------------ Glue Crawler Module Variables ------------------------

variable "glue_database_name" {
  description = "Name of the Glue database"
  type        = string
}

variable "glue_crawler_name" {
  description = "Name of the Glue crawler"
  type        = string
}

variable "glue_crawler_schedule" {
  description = "Schedule for the Glue crawler"
  type        = string
}

variable "glue_table_prefix" {
  description = "Prefix for Glue table names"
  type        = string
}

variable "glue_prefix" {
  description = "Prefix for Glue resource names"
  type        = string
}

variable "glue_crawler_description" {
  description = "Description for the Glue crawler"
  type        = string
}

variable "classifiers" {
  description = "List of classifiers to use in Glue crawler"
  type        = list(string)
  default     = []
}

variable "configuration" {
  description = "Glue crawler configuration as a JSON string"
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

# ------------------------ Athena S3 Results Bucket Module Variables ------------------------

variable "athena_s3_results_bucket_name" {
  description = "Name of the S3 bucket for Athena query results"
  type        = string
}

variable "athena_enable_versioning" {
  description = "Enable versioning for Athena S3 results bucket"
  type        = bool
}
