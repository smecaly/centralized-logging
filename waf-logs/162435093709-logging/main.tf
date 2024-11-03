##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

# Module to create a KMS encryption key with alias, key rotation, and deletion window settings
module "kms_encryption" {
  source                  = "./modules/kms"
  description             = var.kms_description
  alias_name              = var.kms_alias_name
  deletion_window_in_days = var.kms_deletion_window
  enable_key_rotation     = var.kms_enable_rotation
  tags                    = var.tags
}

# Module to create an S3 bucket for unfiltered WAF logs with versioning and lifecycle policies
module "s3_unfiltered_waf_logs" {
  source                  = "./modules/s3-unfiltered-waf"
  bucket_name             = var.waf_logs_bucket_name
  versioning_enabled      = var.versioning_enabled
  lifecycle_enabled       = var.lifecycle_enabled
  expiration_days         = var.expiration_days
  kinesis_firehose_role_arn = var.kinesis_firehose_role_arn
  logging_account_id      = var.logging_account_id
  infosec_account_id      = var.infosec_account_id
  tags                    = var.tags
}

# Module to create a Glue crawler to process unfiltered WAF logs from S3 with specified configuration
module "glue_crawler_unfiltered" {
  source                   = "./modules/glue-crawler"
  database_name_unfiltered = var.database_name_unfiltered
  crawler_name             = var.crawler_name                       
  s3_target_unfiltered     = [
    {
      path                = "s3://${module.s3_unfiltered_waf_logs.bucket_name}/"
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
  kms_key_arn_unfiltered   = module.kms_encryption.kms_key_arn   # Referencing KMS module directly
  tags                     = var.tags
}


# Module to configure an Athena workgroup with KMS encryption and specified output location in S3
module "athena" {
  source                          = "./modules/athena"
  workgroup_name                  = var.athena_workgroup_name
  s3_output_location              = var.s3_output_location
  kms_key_arn                     = module.kms_encryption.kms_key_arn
  enforce_workgroup_configuration = var.athena_enforce_workgroup_configuration
  prefix                          = var.athena_prefix
  depends_on                      = [module.athena_s3_query_results_bucket]
  tags                            = var.tags
}

# Module to create an S3 bucket for storing Athena query results with encryption and versioning
module "athena_s3_query_results_bucket" {
  source            = "./modules/s3-athena-query-results"
  bucket_name       = var.athena_s3_results_bucket_name
  enable_versioning = var.athena_enable_versioning
  kms_master_key_id = module.kms_encryption.kms_key_arn
  lifecycle_enabled = var.lifecycle_enabled
  expiration_days   = var.expiration_days
  sse_algorithm     = "aws:kms"
  tags              = var.tags
}
