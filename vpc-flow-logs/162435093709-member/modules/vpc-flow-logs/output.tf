output "cloudwatch_flow_logs" {
  description = "Details of the created CloudWatch flow logs"
  value       = aws_flow_log.vpc_flow_log_cloudwatch
}

output "s3_flow_logs" {
  description = "Details of the created S3 flow logs"
  value       = aws_flow_log.vpc_flow_log_s3
}

output "subscription_filters" {
  description = "Details of the created CloudWatch subscription filters"
  value       = aws_cloudwatch_log_subscription_filter.vpc_flow_log_filter
}
