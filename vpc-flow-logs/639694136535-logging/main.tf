##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

# Module to create an S3 bucket for flow logs with a policy allowing cross-account access
module "flow_logs_s3_bucket" {
  source              = "./modules/s3-flow-logs"
  bucket_name         = var.bucket_name
  tags                = var.tags
  versioning_enabled  = var.versioning_enabled
  lifecycle_enabled   = var.lifecycle_enabled
  expiration_days     = var.expiration_days
  source_account_ids    = var.source_account_ids
}

# Module to create a Glue crawler to process unfiltered WAF logs from S3 with specified configuration
module "glue_crawler" {
  source                   = "./modules/glue-crawler"
  database_name_unfiltered = var.database_name_unfiltered
  crawler_name             = var.crawler_name
  s3_target_unfiltered     = [
    {
      path                = "s3://${module.flow_logs_s3_bucket.bucket_name}/"
      connection_name     = null
      exclusions          = []
      event_queue_arn     = null
      dlq_event_queue_arn = null
    }
  ]
  schedule_unfiltered      = var.schedule_unfiltered
  prefix                   = var.prefix
  crawler_description      = var.crawler_description
  configuration_unfiltered = var.configuration_unfiltered
  kms_key_arn_unfiltered   = var.kms_key_arn  
  tags                     = var.tags
}

# Module to configure an Athena workgroup with KMS encryption and specified output location in S3
module "athena" {
  source                          = "./modules/athena"
  workgroup_name                  = var.athena_workgroup_name
  s3_output_location              = var.s3_output_location
  kms_key_arn                     = var.kms_key_arn  
  enforce_workgroup_configuration = var.athena_enforce_workgroup_configuration
  prefix                          = var.athena_prefix
  tags                            = var.tags
}
