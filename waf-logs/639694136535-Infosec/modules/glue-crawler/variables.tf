##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

variable "crawler_count" {
  description = "Number of Glue crawlers to create"
  type        = number
  default     = 1
}

variable "crawler_name" {
  description = "The name of the Glue crawler"
  type        = string
}

variable "crawler_description" {
  description = "The description for the Glue crawler"
  type        = string
}

variable "database_name" {
  description = "The name of the Glue catalog database"
  type        = string
}

variable "schedule" {
  description = "The cron expression for scheduling the Glue crawler"
  type        = string
  default     = ""
}

variable "classifiers" {
  description = "Classifiers to be used by the Glue crawler (optional)"
  type        = list(string)
  default     = []
}

variable "configuration" {
  description = "Glue crawler configuration in JSON format (optional)"
  type        = string
  default     = ""
}

variable "table_prefix" {
  description = "The prefix for the tables created by the Glue crawler"
  type        = string
  default     = "waf_logs_"
}

variable "s3_target" {
  description = "A list of S3 target configurations for the Glue crawler to scan and catalog data. Each target contains details about the S3 path (location of data), optional connection settings, exclusions (for paths or files to skip), and optional event-driven queues (to process new objects or failures). This allows Glue to extract metadata from the specified S3 location and automatically catalog the data into the Glue Data Catalog."
  type = list(object({
    path                = string                      # The S3 path where the data is located
    connection_name     = optional(string)            # Optional name of the connection to use for accessing the target
    exclusions          = optional(list(string))      # Optional list of file patterns to exclude from the scan
    event_queue_arn     = optional(string)            # Optional ARN of an SQS queue for event-based processing
    dlq_event_queue_arn = optional(string)            # Optional ARN of a dead-letter queue to handle failures
  }))
}

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default     = {}
}

variable "prefix" {
  description = "Prefix for Glue and related resource names"
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key used for decryption"
  type        = string
}

