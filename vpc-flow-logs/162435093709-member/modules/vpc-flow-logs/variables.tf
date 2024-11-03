
variable "iam_role_name" {
  description = "The name of the IAM role for VPC flow logs"
  type        = string
  default     = "vpc-flow-log-role"
}

variable "iam_policy_name" {
  description = "The name of the IAM policy for VPC flow logs"
  type        = string
  default     = "vpc-flow-log-policy"
}

variable "kinesis_cloudwatch_destination_arn" {
  description = "The ARN of the Kinesis stream in the infosec account to which CloudWatch logs are sent"
  type        = string
}

variable "filter_pattern" {
  description = "The filter pattern for the CloudWatch subscription filter"
  type        = string
  default     = "{ $.interfaceId = \"eni-*\" }"  # Modify as needed
}

variable "s3_log_destination_arn" {
  description = "The ARN of the S3 bucket for storing VPC flow logs"
  type        = string
}

variable "retention_in_days" {
  description = "The retention period in days for the CloudWatch log groups"
  type        = number
  default     = 30  # Customize as needed
}

variable "s3_log_prefix" {
  description = "The S3 key prefix for organizing VPC flow logs by accountID"
  type        = string
  default     = "vpcflowlogs"  # Customize as needed
}
