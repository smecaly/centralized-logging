##############################################################################################################################
# CloudWatch Log Destination Variables
##############################################################################################################################

variable "destination_name" {
  description = "The name of the CloudWatch log destination."
  type        = string
}

variable "kinesis_arn" {
  description = "The ARN of the Kinesis stream to which CloudWatch logs will be sent."
  type        = string
}

variable "source_account_ids" {
  description = "List of source account IDs allowed to use this CloudWatch log destination."
  type        = list(string)
}

variable "destination_role_arn" {
  description = "The ARN of the IAM role that CloudWatch Logs will assume to publish to Kinesis."
  type        = string
}
