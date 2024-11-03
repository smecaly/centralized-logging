##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

variable "stream_name" {
  description = "Name of the Kinesis Data Stream"
  type        = string
}

variable "stream_mode" {
  description = "Stream mode for the Kinesis Data Stream, either 'ON_DEMAND' or 'PROVISIONED'"
  type        = string
  default     = "PROVISIONED"
}

variable "shard_count" {
  description = "Number of shards in the Kinesis Data Stream if using PROVISIONED mode"
  type        = number
  default     = 1
}

variable "retention_period" {
  description = "Retention period of data in the Kinesis Data Stream (in hours)"
  type        = number
  default     = 24
}

variable "shard_level_metrics" {
  description = "List of shard-level metrics to enable"
  type        = list(string)
  default     = []
}

variable "enforce_consumer_deletion" {
  description = "Whether to enforce consumer deletion"
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "Encryption type for the Kinesis Data Stream (either 'KMS' or 'NONE')"
  type        = string
  default     = "KMS"
}

variable "kms_key_id" {
  description = "KMS Key ID for Kinesis Data Stream encryption, required if encryption_type is 'KMS'"
  type        = string
  default     = null
}

variable "consumer_enabled" {
  description = "Whether to create a Kinesis Stream Consumer"
  type        = bool
  default     = false
}

variable "consumer_count" {
  description = "Number of Kinesis Stream Consumers to create if consumer_enabled is true"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Tags to assign to the Kinesis resources"
  type        = map(string)
  default     = {}
}
