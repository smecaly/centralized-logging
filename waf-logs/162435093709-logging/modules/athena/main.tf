##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

resource "aws_athena_workgroup" "workgroup" {
  name = var.workgroup_name

  configuration {
    result_configuration {
      output_location = var.s3_output_location
    }

    enforce_workgroup_configuration = var.enforce_workgroup_configuration
  }

  state = "ENABLED"

  tags = var.tags
}

resource "aws_iam_role" "athena_execution_role" {
  name = "${var.prefix}-query-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "athena.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_policy" "athena_policy" {
  name = "${var.prefix}QueryExecutionPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${var.s3_output_location}",
          "arn:aws:s3:::${var.s3_output_location}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "glue:GetTable",
          "glue:GetTableVersion",
          "glue:GetTableVersions"
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

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.athena_execution_role.name
  policy_arn = aws_iam_policy.athena_policy.arn
}
