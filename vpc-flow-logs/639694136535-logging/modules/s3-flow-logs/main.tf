##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

resource "aws_s3_bucket" "flow_logs_bucket" {
  bucket = var.bucket_name

  tags = var.tags
}

resource "aws_s3_bucket_versioning" "flow_logs_bucket_versioning" {
  bucket = aws_s3_bucket.flow_logs_bucket.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "flow_logs_bucket_lifecycle" {
  bucket = aws_s3_bucket.flow_logs_bucket.id

  rule {
    id     = "auto-expire"
    status = var.lifecycle_enabled ? "Enabled" : "Disabled"

    expiration {
      days = var.expiration_days
    }
  }
}

resource "aws_s3_bucket_policy" "flow_logs_bucket_policy" {
  bucket = aws_s3_bucket.flow_logs_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Principal = "*",
        Action = [
          "s3:Put*",
          "s3:Get*",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.flow_logs_bucket.arn}",
          "${aws_s3_bucket.flow_logs_bucket.arn}/*"
        ],
        Condition = {
          StringEquals = {
            "aws:SourceAccount": var.source_account_ids
          }
        }
      }
    ]
  })
}

