##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

resource "aws_iam_role" "unfiltered_firehose" {
  name_prefix        = "${var.iam_name_prefix}_unfiltered"
  description        = "IAM Role for Unfiltered Kinesis Firehose to assume necessary permissions"
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

resource "aws_iam_policy" "unfiltered_firehose_s3_cloudwatch_kms" {
  name_prefix = "${var.iam_name_prefix}_unfiltered"
  description = "Policy granting Unfiltered Firehose access to S3, CloudWatch Logs, and KMS"

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
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "${var.unfiltered_bucket_arn}",
        "${var.unfiltered_bucket_arn}/*"
      ]
    },
    {
      "Sid": "CloudWatchLogsPermissions",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:CreateLogGroup"
      ],
      "Resource": "*"
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

resource "aws_iam_role_policy_attachment" "unfiltered_firehose_policy_attachment" {
  role       = aws_iam_role.unfiltered_firehose.name
  policy_arn = aws_iam_policy.unfiltered_firehose_s3_cloudwatch_kms.arn
}




