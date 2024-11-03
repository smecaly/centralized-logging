##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

variable "filtered_firehose_name" {
  description = "Name of the Kinesis Firehose stream"
  type        = string
}

variable "bucket_arn" {
  description = "The ARN of the S3 bucket where data will be stored"
  type        = string
}

variable "backup_bucket_arn" {
  description = "The ARN of the S3 for failed records"
  type        = string
}

variable "iam_name_prefix" {
  description = "Prefix for naming IAM roles and policies"
  type        = string
}

variable "tags" {
  description = "Tags to assign to all resources"
  type        = map(string)
}

variable "lambda_timeout" {
  type        = number
  default     = 300
  description = "Lambda Timeout"
}

variable "function_name" {
  type        = string
  default     = "data-transform-lambda"
  description = "Lambda Function Name"
}

variable "retention_in_days" {
  description = "Retention period for CloudWatch log group"
  type        = number
  default     = 14
}

