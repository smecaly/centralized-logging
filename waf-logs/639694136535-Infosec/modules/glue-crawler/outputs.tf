##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

output "glue_crawler_name" {
  value = aws_glue_crawler.glue_crawler_main[0].name
}

output "glue_crawler_arn" {
  value = aws_glue_crawler.glue_crawler_main[0].arn
}

