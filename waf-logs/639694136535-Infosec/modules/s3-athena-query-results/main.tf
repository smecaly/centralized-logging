##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

resource "aws_s3_bucket" "athena_results" {
  bucket = var.bucket_name
  tags = var.tags
}

resource "aws_s3_bucket_versioning" "athena_results_versioning" {
  bucket = aws_s3_bucket.athena_results.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "athena_results_sse" {
  bucket = aws_s3_bucket.athena_results.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.kms_master_key_id  # If using KMS
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "athena_results_lifecycle" {
  bucket = aws_s3_bucket.athena_results.id

  rule {
    id      = "auto-expire"
    status  = var.lifecycle_enabled ? "Enabled" : "Disabled"

    expiration {
      days = var.expiration_days  
    }
  }
}

resource "aws_s3_bucket_policy" "athena_results_policy" {
  bucket = aws_s3_bucket.athena_results.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          "Service": "athena.amazonaws.com"
        },
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = [
          "${aws_s3_bucket.athena_results.arn}/*" 
        ]
      },
      {
        Effect = "Allow",
        Principal = {
          "Service": "athena.amazonaws.com"
        },
        Action = "s3:GetBucketLocation",
        Resource = "${aws_s3_bucket.athena_results.arn}" 
      }
    ]
  })
}


