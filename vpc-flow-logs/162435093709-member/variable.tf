variable "kinesis_cloudwatch_destination_arn" {
  description = "The ARN of the Kinesis stream in the infosec account to which CloudWatch logs are sent"
  type        = string
}

variable "filter_pattern" {
  description = "The filter pattern for the CloudWatch subscription filter"
  type        = string
}

variable "s3_log_destination_arn" {
  description = "The ARN of the S3 bucket for storing VPC flow logs in the centralized logging account"
  type        = string
}

variable "retention_in_days" {
  description = "The retention period in days for the CloudWatch log groups"
  type        = number
}

variable "iam_role_name" {
  description = "The name of the IAM role for VPC flow logs"
  type        = string
}

variable "iam_policy_name" {
  description = "The name of the IAM policy for VPC flow logs"
  type        = string
}
