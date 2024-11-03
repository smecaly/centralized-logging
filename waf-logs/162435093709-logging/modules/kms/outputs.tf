##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

output "kms_key_arn" {
  description = "The ARN of the KMS Key"
  value       = aws_kms_key.encryption_key.arn
}

output "kms_key_id" {
  description = "The ID of the KMS Key"
  value       = aws_kms_key.encryption_key.id
}

output "kms_key_alias" {
  description = "The alias of the KMS Key"
  value       = aws_kms_alias.encryption_key_alias.name
}
