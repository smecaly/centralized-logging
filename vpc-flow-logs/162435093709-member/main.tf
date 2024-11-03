module "vpc_flow_logs" {
  source                       = "./modules/vpc-flow-logs"  # Path to your module
  kinesis_cloudwatch_destination_arn      = var.kinesis_cloudwatch_destination_arn
  filter_pattern               = var.filter_pattern
  s3_log_destination_arn       = var.s3_log_destination_arn
  retention_in_days            = var.retention_in_days
  iam_role_name                = var.iam_role_name
  iam_policy_name              = var.iam_policy_name
}
