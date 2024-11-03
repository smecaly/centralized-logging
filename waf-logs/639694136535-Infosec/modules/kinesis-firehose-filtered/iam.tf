##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

resource "aws_iam_role" "filtered_firehose" {
  name_prefix        = "${var.iam_name_prefix}_filtered"
  description        = "IAM Role for Kinesis Firehose to assume necessary permissions"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AssumeFirehoseRole",
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "firehose.amazonaws.com"
                ]
            }
        }
    ]
}
EOF
}

# IAM Policy for Kinesis Firehose to interact with S3, CloudWatch Logs, Lambda, and KMS
resource "aws_iam_policy" "firehose_s3_cloudwatch_lambda_kms" {
  name_prefix = "${var.iam_name_prefix}_filtered"
  description = "Policy granting Firehose access to S3, CloudWatch Logs, Lambda, and KMS"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3BucketPermissions",
      "Effect": "Allow",
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:Get*",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:Put*"
      ],
      "Resource": [
        "${var.bucket_arn}",
        "${var.bucket_arn}/*",
        "${var.backup_bucket_arn}",
        "${var.backup_bucket_arn}/*"
      ]
    },
    {
      "Sid": "CloudWatchLogsPermissions",
      "Effect": "Allow",
      "Action": [
        "logs:PutSubscriptionFilter",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:CreateLogGroup"
      ],
      "Resource": "*"
    },
    {
      "Sid": "LambdaPermissions",
      "Effect": "Allow",
      "Action": [
        "lambda:InvokeFunction",
        "lambda:GetFunctionConfiguration"
      ],
      "Resource": "${aws_lambda_function.data_transformer.arn}"
    },
    {
      "Sid": "KMSEncryptionPermissions",
      "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:GenerateDataKey",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "firehose_s3_cloudwatch_lambda_kms_attachment" {
  role       = aws_iam_role.filtered_firehose.name
  policy_arn = aws_iam_policy.firehose_s3_cloudwatch_lambda_kms.arn
}

resource "aws_iam_role" "lambda_exec" {
  name_prefix        = "lambda_exec"
  description        = "IAM Role for Lambda execution"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AssumeLambdaRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_policy" {
  name_prefix = "lambda_exec_policy"
  description = "Policy granting Lambda access to S3 and CloudWatch Logs"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3Permissions",
      "Effect": "Allow",
      "Action": [
        "s3:Get*",
        "s3:Put*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "CloudWatchLogsPermissions",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
