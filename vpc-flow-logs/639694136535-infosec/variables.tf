# ------------------------ KMS Encryption Module Variables ------------------------
variable "kms_description" {
  description = "Description for the KMS key"
  type        = string
}

variable "kms_alias_name" {
  description = "Alias name for the KMS key"
  type        = string
}

variable "kms_deletion_window" {
  description = "Number of days for KMS key deletion window"
  type        = number
  default     = 30
}

variable "kms_enable_rotation" {
  description = "Enable key rotation for the KMS key"
  type        = bool
  default     = true
}

# ------------------------ CloudWatch Logs Destination Module Variables ------------------------
variable "source_account_ids" {
  description = "List of source account IDs that will access the CloudWatch destination"
  type        = list(string)
}

variable "destination_account_id" {
  description = "ID of the account where the CloudWatch destination is configured"
  type        = string
}

variable "cloudwatch_destination_name" {
  description = "Name of the CloudWatch log destination"
  type        = string
}

variable "region" {
  description = "AWS region for CloudWatch destination"
  type        = string
}

# ------------------------ Kinesis Firehose Module Variables ------------------------
variable "kinesis_firehose_name" {
  description = "Name for the Kinesis Firehose delivery stream"
  type        = string
}

variable "kinesis_firehose_iam_prefix" {
  description = "IAM prefix for the Kinesis Firehose"
  type        = string
}

variable "kinesis_cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group for Kinesis Firehose monitoring"
  type        = string
}

variable "kinesis_cloudwatch_log_stream_name" {
  description = "Name of the CloudWatch log stream for Kinesis Firehose monitoring"
  type        = string
}

variable "vpc_cidr_ranges" {
  description = "List of VPC CIDR ranges for access control"
  type        = list(string)
}

variable "function_name" {
  type        = string
  description = "Lambda Function Name"
}

# ------------------------ Kinesis Firehose S3 Logs Module Variables ------------------------
variable "kinesis_s3_bucket_name" {
  description = "Name of the S3 bucket for Kinesis Firehose logs"
  type        = string
}

variable "kinesis_s3_versioning_enabled" {
  description = "Enable versioning for the Kinesis Firehose S3 bucket"
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
variable "glue_database_name" {
  description = "Name of the Glue database for the crawler"
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
  description = "Prefix for tables created by the Glue crawler"
  type        = string
}

variable "glue_prefix" {
  description = "Prefix for resources created by the Glue crawler module"
  type        = string
}

variable "glue_crawler_description" {
  description = "Description for the Glue crawler"
  type        = string
}

variable "classifiers" {
  description = "List of classifiers to use with the Glue crawler"
  type        = list(string)
  default     = []
}

variable "configuration" {
  description = "Additional configuration for the Glue crawler"
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
  default     = true
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
  description = "Enable versioning for the Athena S3 query results bucket"
  type        = bool
  default     = true
}

# ------------------------ Global Variables ------------------------
variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {
    Environment = "Production"
    Project     = "Centralized Logging"
  }
}
