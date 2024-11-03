##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

# Module to create a KMS encryption key with alias, rotation, and lifecycle policies
module "kms_encryption" {
  source                  = "./modules/kms"
  description             = var.kms_description
  alias_name              = var.kms_alias_name
  deletion_window_in_days = var.kms_deletion_window
  enable_key_rotation     = var.kms_enable_rotation
  tags                    = var.tags
}

# Module to create the IAM role for CloudWatch Kinesis access across multiple accounts
module "cloudwatch_destination_role" {
  source                 = "./modules/cloudwatch_destination_role"
  prefix                 = var.prefix
  source_account_ids     = var.source_account_ids
  region                 = var.region
  destination_account_id = var.destination_account_id
  kms_key_arn            = module.kms_encryption.kms_key_arn
}

# Module for creating the filtered CloudWatch Logs destination with Kinesis stream target
module "cloudwatch_logs_destination_filtered" {
  source                 = "./modules/cloudwatch_destination"
  source_account_ids     = var.source_account_ids  
  kinesis_arn            = module.kinesis_firehose_filtered.stream_arn
  destination_name       = var.cloudwatch_destination_name_filtered
  destination_role_arn   = module.cloudwatch_destination_role.cloudwatch_kinesis_role_arn
}

# Module for creating the unfiltered CloudWatch Logs destination with Kinesis stream target
module "cloudwatch_logs_destination_unfiltered" {
  source                 = "./modules/cloudwatch_destination"
  source_account_ids     = var.source_account_ids  
  kinesis_arn            = module.kinesis_firehose_unfiltered.stream_arn
  destination_name       = var.cloudwatch_destination_name_unfiltered
  destination_role_arn   = module.cloudwatch_destination_role.cloudwatch_kinesis_role_arn
}

# Module to create a filtered Kinesis Firehose stream delivering to S3 with backup
module "kinesis_firehose_filtered" {
  source                     = "./modules/kinesis-firehose-filtered"
  filtered_firehose_name     = var.filtered_firehose_name
  bucket_arn                 = module.kinesis_firehose_s3_logs.bucket_arn
  backup_bucket_arn          = module.kinesis_firehose_s3_logs.bucket_arn
  iam_name_prefix            = var.iam_name_prefix 
  tags                       = var.tags
}

# Module to create an unfiltered Kinesis Firehose stream delivering logs to S3
module "kinesis_firehose_unfiltered" {
  source                     = "./modules/kinesis-firehose-unfiltered"
  unfiltered_firehose_name   = var.kinesis_firehose_unfiltered_name
  unfiltered_bucket_arn      = var.unfiltered_bucket_arn
  iam_name_prefix            = var.iam_name_prefix 
  tags                       = var.tags
}

# Module to create an S3 bucket for curated logs from Kinesis Firehose with lifecycle policies
module "kinesis_firehose_s3_logs" {
  source                 = "./modules/s3-kinesis-curated"
  bucket_name            = var.kinesis_s3_bucket_name
  versioning_enabled     = var.kinesis_s3_versioning_enabled
  sse_algorithm          = "aws:kms"
  kms_master_key_id      = module.kms_encryption.kms_key_arn
  lifecycle_enabled      = var.lifecycle_enabled
  expiration_days        = var.expiration_days
  destination_account_id = var.destination_account_id
  firehose_role_arn      = module.kinesis_firehose_filtered.firehose_role_arn
  tags                   = var.tags
}

# Module to create and configure a Glue crawler with an S3 data source
module "glue_crawler" {
  source             = "./modules/glue-crawler"
  database_name      = var.glue_database_name
  crawler_name       = var.glue_crawler_name
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
  classifiers         = var.classifiers
  configuration       = var.configuration 
  kms_key_arn         = module.kms_encryption.kms_key_arn
  tags                = var.tags  
}

# Module to configure an Athena workgroup with encryption and output location in S3
module "athena" {
  source                          = "./modules/athena"
  workgroup_name                  = var.athena_workgroup_name
  s3_output_location              = var.s3_output_location
  kms_key_arn                     = module.kms_encryption.kms_key_arn
  enforce_workgroup_configuration = var.athena_enforce_workgroup_configuration
  prefix                          = var.athena_prefix
  depends_on                      = [module.athena_s3_results_bucket]
  tags                            = var.tags
}

# Module to create an S3 bucket for storing Athena query results with encryption
module "athena_s3_results_bucket" {
  source            = "./modules/s3-athena-query-results"
  bucket_name       = var.athena_s3_results_bucket_name
  enable_versioning = var.athena_enable_versioning
  kms_master_key_id = module.kms_encryption.kms_key_arn
  lifecycle_enabled = var.lifecycle_enabled
  expiration_days   = var.expiration_days
  sse_algorithm     = "aws:kms"
  tags              = var.tags
}

