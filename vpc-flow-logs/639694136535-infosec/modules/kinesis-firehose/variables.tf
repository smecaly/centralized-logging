##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

variable "name" {
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

variable "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch log group for Kinesis Firehose error logging"
  type        = string
}

variable "cloudwatch_log_stream_name" {
  description = "The name of the CloudWatch log stream for Kinesis Firehose error logging"
  type        = string
}

variable "lambda_timeout" {
  type        = number
  default     = 300
  description = "Lambda Timeout"
}

variable "function_name" {
  type        = string
  description = "Lambda Function Name"
}

variable "retention_in_days" {
  description = "Retention period for CloudWatch log group"
  type        = number
  default     = 14
}

variable "vpc_cidr_ranges" {
  description = "List of VPC CIDR ranges for access control"
  type        = list(string)
}

