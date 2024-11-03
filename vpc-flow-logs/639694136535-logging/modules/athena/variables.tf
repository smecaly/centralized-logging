##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

variable "workgroup_name" {
  description = "Name of the Athena workgroup"
  type        = string
}

variable "enforce_workgroup_configuration" {
  description = "Whether to enforce the workgroup configuration"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default     = {}
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key used for decryption"
  type        = string
}

variable "s3_output_location" {
  description = "The S3 bucket where Athena query results will be stored"
  type        = string
}
