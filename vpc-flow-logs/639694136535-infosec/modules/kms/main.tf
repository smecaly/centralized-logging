##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

data "aws_caller_identity" "current" {}

# Create a KMS Key for encryption
resource "aws_kms_key" "encryption_key" {
  description             = var.description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  key_usage               = "ENCRYPT_DECRYPT"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
          var.firehose_arn
          ]
        },
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

# Optionally create an alias for the key
resource "aws_kms_alias" "encryption_key_alias" {
  name          = "alias/${var.alias_name}"
  target_key_id = aws_kms_key.encryption_key.id
}
