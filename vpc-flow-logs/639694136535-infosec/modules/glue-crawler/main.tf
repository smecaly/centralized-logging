##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

resource "aws_glue_crawler" "glue_crawler_main" {
  count                   = var.crawler_count
  name                    = "${var.crawler_name}-${count.index + 1}"
  description             = var.crawler_description
  database_name           = aws_glue_catalog_database.glue.name
  role                    = aws_iam_role.glue_role.arn
  schedule                = var.schedule
  classifiers             = var.classifiers
  configuration           = var.configuration
  table_prefix            = var.table_prefix

  dynamic "s3_target" {
    for_each = var.s3_target != null ? var.s3_target : []
    content {
      path                = s3_target.value.path
      connection_name     = try(s3_target.value.connection_name, null)
      
      # Adding exclusion to prevent crawling processing-failed paths
      exclusions          = try(s3_target.value.exclusions, ["*/processing-failed/*"])
      
      event_queue_arn     = try(s3_target.value.event_queue_arn, null)
      dlq_event_queue_arn = try(s3_target.value.dlq_event_queue_arn, null)
    }
  }

  tags = var.tags
}


resource "aws_glue_catalog_database" "glue" {
  name = var.database_name
}

resource "aws_iam_role" "glue_role" {
  name = "${var.prefix}ServiceRole"

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

resource "aws_iam_policy" "glue_policy" {
  name = "${var.prefix}ServicePolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid: "GlueAndS3Permissions",
        Effect: "Allow",
        Action: [
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
        Effect: "Allow",
        Action: "kms:Decrypt",
        Resource = var.kms_key_arn 
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "glue_role_attachment" {
  role       = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.glue_policy.arn
}
