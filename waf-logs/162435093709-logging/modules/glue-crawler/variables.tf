##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

# ------------------------ Glue Crawler Module Variables ------------------------

variable "crawler_count" {
  description = "The number of Glue crawlers to create."
  type        = number
  default     = 1
}

variable "crawler_name" {
  description = "The base name for the Glue crawler."
  type        = string
}

variable "crawler_description" {
  description = "The description for the Glue crawler."
  type        = string
}

variable "database_name_unfiltered" {
  description = "The name of the Glue catalog database for unfiltered logs."
  type        = string
}

variable "schedule_unfiltered" {
  description = "The cron expression for scheduling the unfiltered Glue crawler."
  type        = string
  default     = ""
}

variable "configuration_unfiltered" {
  description = "Glue crawler configuration in JSON format for unfiltered logs."
  type        = string
  default     = ""
}

variable "s3_target_unfiltered" {
  description = "S3 target paths and configurations for the unfiltered Glue crawler."
  type = list(object({
    path                = string
    connection_name     = string
    exclusions          = list(string)
    event_queue_arn     = string
    dlq_event_queue_arn = string
  }))
}

variable "tags" {
  description = "Tags to apply to Glue resources."
  type        = map(string)
  default     = {}
}

variable "prefix" {
  description = "Prefix for Glue and related resource names."
  type        = string
}

variable "kms_key_arn_unfiltered" {
  description = "The KMS key ARN used to decrypt data for unfiltered logs."
  type        = string
}
