##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

variable "source_account_ids" {
  type        = list(string)
  description = "List of AWS account IDs that are allowed to put subscription filters."
}

variable "destination_account_id" {
  description = "The recipient account ID for CloudWatch Logs"
  type        = string
}

variable "region" {
  description = "The AWS region where the resources are deployed"
  type        = string
}
variable "kinesis_arn" {
  type = string
}
variable "destination_name" {

}
variable "prefix" {
  type    = string
  default = "Cloudwatch"
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key used to encrypt the Kinesis stream"
  type        = string
}
