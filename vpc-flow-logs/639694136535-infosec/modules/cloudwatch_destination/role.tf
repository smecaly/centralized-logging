##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

resource "aws_iam_role" "cloudwatch_kinesis_role" {
  name = "${var.prefix}_kinesis_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "logs.amazonaws.com"
        },
        Action = "sts:AssumeRole",
        Condition = {
          StringLike = {
            "aws:SourceArn" = concat(
              [for account_id in var.source_account_ids : "arn:aws:logs:${var.region}:${account_id}:*"],
              ["arn:aws:logs:${var.region}:${var.destination_account_id}:*"],
              ["arn:aws:logs:${var.region}:*:root"] # Include all accounts under the organization
            )
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "cloudwatch_kinesis_policy" {
  name = "${var.prefix}_kinesis_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "kinesis:PutRecord",
          "kinesis:PutRecords",
          "kinesis:DescribeStream",
          "kinesis:ListShards"
        ],
        Effect   = "Allow",
        Resource = var.kinesis_arn
      },
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:${var.region}:${var.destination_account_id}:log-group:*"
      },
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ],
        Effect   = "Allow",
        Resource = var.kms_key_arn
      },
      {
        Sid: "FullAdminAccess",
        Effect: "Allow",
        Action: "*",
        Resource: "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_kinesis_policy" {
  role       = aws_iam_role.cloudwatch_kinesis_role.name
  policy_arn = aws_iam_policy.cloudwatch_kinesis_policy.arn
}
