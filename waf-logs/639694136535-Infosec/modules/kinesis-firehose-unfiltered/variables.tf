##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

# ------------------------ Kinesis Firehose Delivery Stream Module Variables ------------------------

variable "unfiltered_firehose_name" {
  description = "Name of the Kinesis Firehose delivery stream for unfiltered data"
  type        = string
}

variable "unfiltered_bucket_arn" {
  description = "ARN of the S3 bucket where unfiltered Firehose data will be stored"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the Firehose delivery stream"
  type        = map(string)
}

variable "iam_name_prefix" {
  description = "Prefix for naming IAM roles and policies"
  type        = string
}



