##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

resource "aws_s3_bucket" "s3_kinesis" {
  bucket = var.bucket_name

  tags = var.tags
}


resource "aws_s3_bucket_versioning" "s3_kinesis_versioning" {
  bucket = aws_s3_bucket.s3_kinesis.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_kinesis_sse" {
  bucket = aws_s3_bucket.s3_kinesis.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.kms_master_key_id  # If using KMS
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_kinesis_lifecycle" {
  bucket = aws_s3_bucket.s3_kinesis.id

  rule {
    id      = "auto-expire"
    status  = var.lifecycle_enabled ? "Enabled" : "Disabled"

    expiration {
      days = var.expiration_days
    }
  }
}


resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3_kinesis.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "AllowSpecificIAMRolesAndAccounts",
        Effect   = "Allow",
        Principal = {
          "AWS": [  
            "${var.destination_account_id}" 
          ]
        },
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.s3_kinesis.arn}",
          "${aws_s3_bucket.s3_kinesis.arn}/*"
        ]
      }
    ]
  })
}
