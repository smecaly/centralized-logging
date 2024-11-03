##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

variable "prefix" {
  description = "Prefix for naming IAM resources (role and policy) for CloudWatch Kinesis access."
  type        = string
}

variable "source_account_ids" {
  description = "List of source account IDs allowed to assume the CloudWatch Kinesis role."
  type        = list(string)
}

variable "region" {
  description = "The AWS region where the resources are created."
  type        = string
}

variable "destination_account_id" {
  description = "The destination account ID where the CloudWatch Logs and Kinesis resources are located."
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key used for encrypting data in the Kinesis stream."
  type        = string
}
