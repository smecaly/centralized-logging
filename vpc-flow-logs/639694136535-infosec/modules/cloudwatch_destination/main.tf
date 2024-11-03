##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

resource "aws_cloudwatch_log_destination" "destination" {
  name       = var.destination_name
  role_arn   = aws_iam_role.cloudwatch_kinesis_role.arn
  target_arn = var.kinesis_arn
}

resource "aws_cloudwatch_log_destination_policy" "policy" {
  destination_name = aws_cloudwatch_log_destination.destination.name

  access_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = var.source_account_ids
        },
        Action   = "logs:PutSubscriptionFilter",
        Resource = aws_cloudwatch_log_destination.destination.arn
      }
    ]
  })
}
