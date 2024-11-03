# Step 1: Discover all VPCs in the account
data "aws_vpcs" "all_vpcs" {}

# Step 2: Retrieve the current region and account ID dynamically
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Step 3: Create a CloudWatch log group for each VPC
resource "aws_cloudwatch_log_group" "vpc_log_group" {
  for_each = toset(data.aws_vpcs.all_vpcs.ids)

  name              = format("/aws/vpc/flow-logs/%s", each.key)
  retention_in_days = var.retention_in_days  # Use variable for retention period
}

# Step 4: Create a CloudWatch flow log for each VPC
resource "aws_flow_log" "vpc_flow_log_cloudwatch" {
  for_each = toset(data.aws_vpcs.all_vpcs.ids)

  vpc_id          = each.key
  log_destination = aws_cloudwatch_log_group.vpc_log_group[each.key].arn
  iam_role_arn    = aws_iam_role.vpc_flow_log_role.arn
  traffic_type    = "ALL"

  tags = {
    Name = "infosec-cloudwatch-${each.key}"
  }
}

# Step 5: Create a CloudWatch subscription filter to send logs to a Kinesis stream in the infosec account
resource "aws_cloudwatch_log_subscription_filter" "vpc_flow_log_filter" {
  for_each = toset(data.aws_vpcs.all_vpcs.ids)

  name             = format("vpc-flow-log-filter-%s", each.key)
  log_group_name   = aws_cloudwatch_log_group.vpc_log_group[each.key].name
  destination_arn  = var.kinesis_cloudwatch_destination_arn  # Kinesis stream ARN in another account
  filter_pattern   = var.filter_pattern
  distribution     = "ByLogStream"
}

# Step 6: Create an S3 flow log for each VPC
resource "aws_flow_log" "vpc_flow_log_s3" {
  for_each = toset(data.aws_vpcs.all_vpcs.ids)

  vpc_id               = each.key
  log_destination      = var.s3_log_destination_arn
  log_destination_type = "s3"  # Specify that the destination type is S3
  traffic_type         = "ALL"

  tags = {
    Name = "infosec-s3-${each.key}"
  }
}


