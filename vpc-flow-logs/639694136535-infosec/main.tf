##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

module "kms_encryption" {
  source                  = "./modules/kms"
  description             = var.kms_description
  alias_name              = var.kms_alias_name
  deletion_window_in_days = var.kms_deletion_window
  enable_key_rotation     = var.kms_enable_rotation
  firehose_arn = module.kinesis_firehose.firehose_role_arn
  tags                    = var.tags
}

module "cloudwatch_logs_destination" {
  source                 = "./modules/cloudwatch_destination"
  source_account_ids     = var.source_account_ids  
  destination_account_id = var.destination_account_id
  kinesis_arn            = module.kinesis_firehose.stream_arn
  destination_name       = var.cloudwatch_destination_name
  kms_key_arn            = module.kms_encryption.kms_key_arn
  region                 = var.region 
}


module "kinesis_firehose" {
  source                     = "./modules/kinesis-firehose"
  name                       = var.kinesis_firehose_name
  bucket_arn                 = module.kinesis_firehose_s3_logs.bucket_arn
  backup_bucket_arn          = module.kinesis_firehose_s3_logs.bucket_arn 
  iam_name_prefix            = var.kinesis_firehose_iam_prefix
  cloudwatch_log_group_name  = var.kinesis_cloudwatch_log_group_name
  cloudwatch_log_stream_name = var.kinesis_cloudwatch_log_stream_name
    function_name     = var.function_name
  vpc_cidr_ranges            = var.vpc_cidr_ranges  # Pass the VPC CIDR ranges
  tags                       = var.tags
}


module "kinesis_firehose_s3_logs" {
  source                 = "./modules/s3-kinesis-curated"
  bucket_name            = var.kinesis_s3_bucket_name
  versioning_enabled     = var.kinesis_s3_versioning_enabled
  sse_algorithm          = "aws:kms"
  kms_master_key_id      = module.kms_encryption.kms_key_arn
  lifecycle_enabled      = var.lifecycle_enabled
  expiration_days        = var.expiration_days
  destination_account_id = var.destination_account_id
  firehose_role_arn = module.kinesis_firehose.firehose_role_arn
  tags = var.tags
}

module "glue_crawler" {
  source             = "./modules/glue-crawler"
  database_name      = var.glue_database_name
  crawler_name       = var.glue_crawler_name
  
  # S3 target configuration
  s3_target = [
    {
      path                = "s3://${module.kinesis_firehose_s3_logs.bucket_name}/"
      connection_name     = null  
      exclusions          = []    
      event_queue_arn     = null  
      dlq_event_queue_arn = null  
    }
  ]
  
  schedule            = var.glue_crawler_schedule       
  table_prefix        = var.glue_table_prefix           
  prefix              = var.glue_prefix                 
  crawler_description = var.glue_crawler_description    
  
  # Additional settings (optional)
  classifiers         = var.classifiers              
  configuration       = var.configuration 
  kms_key_arn         = module.kms_encryption.kms_key_arn

  tags = var.tags  
}


module "athena" {
  source                          = "./modules/athena"
  workgroup_name                  = var.athena_workgroup_name
  s3_output_location              = var.s3_output_location
  kms_key_arn                     = module.kms_encryption.kms_key_arn
  enforce_workgroup_configuration = var.athena_enforce_workgroup_configuration
  prefix                          = var.athena_prefix
  depends_on    = [module.athena_s3_results_bucket]

  tags = var.tags
}

module "athena_s3_results_bucket" {
  source            = "./modules/s3-athena-query-results"
  bucket_name       = var.athena_s3_results_bucket_name
  enable_versioning = var.athena_enable_versioning
  kms_master_key_id = module.kms_encryption.kms_key_arn
  lifecycle_enabled = var.lifecycle_enabled
  expiration_days   = var.expiration_days
  sse_algorithm     = "aws:kms"

  tags = var.tags
}
