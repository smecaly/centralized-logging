##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

output "glue_crawler_name" {
  description = "The name of the Glue crawler for unfiltered logs."
  value       = aws_glue_crawler.glue_crawler_unfiltered[0].name
}

output "glue_crawler_arn" {
  description = "The ARN of the Glue crawler for unfiltered logs."
  value       = aws_glue_crawler.glue_crawler_unfiltered[0].arn
}

output "glue_database_name" {
  description = "The name of the Glue database for unfiltered logs."
  value       = aws_glue_catalog_database.glue_unfiltered.name
}

output "glue_role_arn" {
  description = "The ARN of the IAM role used by the unfiltered Glue crawler."
  value       = aws_iam_role.glue_role_unfiltered.arn
}

