##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

# Glue Crawler for Unfiltered WAF Logs
resource "aws_glue_crawler" "glue_crawler_unfiltered" {
  count                   = var.crawler_count
  name                    = "${var.crawler_name}-unfiltered-${count.index + 1}"
  description             = var.crawler_description
  database_name           = aws_glue_catalog_database.glue_unfiltered.name
  role                    = aws_iam_role.glue_role_unfiltered.arn
  schedule                = var.schedule_unfiltered
  classifiers = [aws_glue_classifier.json_classifier.name]


  configuration           = var.configuration_unfiltered
  table_prefix            = var.prefix

  dynamic "s3_target" {
    for_each = var.s3_target_unfiltered != null ? var.s3_target_unfiltered : []
    content {
      path                = s3_target.value.path
      connection_name     = try(s3_target.value.connection_name, null)
      exclusions          = try(s3_target.value.exclusions, ["*/processing-failed/*"])
      event_queue_arn     = try(s3_target.value.event_queue_arn, null)
      dlq_event_queue_arn = try(s3_target.value.dlq_event_queue_arn, null)
    }
  }

  tags = var.tags
}

# JSON Classifier targeting entire structure
resource "aws_glue_classifier" "json_classifier" {
  name = "${var.prefix}-json-classifier-entire-structure"

  json_classifier {
    json_path = "$"  # Capture the entire JSON structure, including 'message' as a string
  }
}


# Glue Catalog Database for Unfiltered Logs
resource "aws_glue_catalog_database" "glue_unfiltered" {
  name = var.database_name_unfiltered
}

# IAM Role for Unfiltered Glue Crawler
resource "aws_iam_role" "glue_role_unfiltered" {
  name = "${var.prefix}-unfiltered-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "glue.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for Unfiltered Glue Crawler
resource "aws_iam_policy" "glue_policy_unfiltered" {
  name = "${var.prefix}-unfiltered-service-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid: "GlueAndS3Permissions",
        Effect: "Allow",
        Action = [
          "glue:*",
          "s3:GetObject",
          "s3:ListBucket",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Sid: "KMSDecryptPermissions",
        Effect = "Allow",
        Action = "kms:Decrypt",
        Resource = var.kms_key_arn_unfiltered  # Unique KMS key for unfiltered logs, if different
      }
    ]
  })
}

# Attach IAM Policy to Unfiltered Glue Crawler Role
resource "aws_iam_role_policy_attachment" "glue_role_attachment_unfiltered" {
  role       = aws_iam_role.glue_role_unfiltered.name
  policy_arn = aws_iam_policy.glue_policy_unfiltered.arn
}
