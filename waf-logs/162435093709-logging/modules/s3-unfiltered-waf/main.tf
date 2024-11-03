##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

resource "aws_s3_bucket" "waf_logs_bucket" {
  bucket = var.bucket_name

  tags = var.tags
}

resource "aws_s3_bucket_versioning" "waf_logs_bucket_versioning" {
  bucket = aws_s3_bucket.waf_logs_bucket.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

# resource "aws_s3_bucket_server_side_encryption_configuration" "waf_logs_bucket_sse" {
#   bucket = aws_s3_bucket.waf_logs_bucket.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm     = var.sse_algorithm
#       kms_master_key_id = var.kms_master_key_id  # Use the KMS key if specified
#     }
#   }
# }

resource "aws_s3_bucket_lifecycle_configuration" "waf_logs_bucket_lifecycle" {
  bucket = aws_s3_bucket.waf_logs_bucket.id

  rule {
    id      = "auto-expire"
    status  = var.lifecycle_enabled ? "Enabled" : "Disabled"

    expiration {
      days = var.expiration_days
    }
  }
}

resource "aws_s3_bucket_policy" "waf_logs_bucket_policy" {
  bucket = aws_s3_bucket.waf_logs_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "AllowKinesisFirehoseAccess",
        Effect   = "Allow",
        Principal = {
          "AWS": "arn:aws:iam::${var.infosec_account_id}:root"
        },
        Action = [
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.waf_logs_bucket.arn}",
          "${aws_s3_bucket.waf_logs_bucket.arn}/*"
        ]
      },
      {
        Sid      = "AllowLoggingAccountAccess",
        Effect   = "Allow",
        Principal = {
          "AWS": "arn:aws:iam::${var.logging_account_id}:root"
        },
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.waf_logs_bucket.arn}",
          "${aws_s3_bucket.waf_logs_bucket.arn}/*"
        ]
      }
    ]
  })
}

