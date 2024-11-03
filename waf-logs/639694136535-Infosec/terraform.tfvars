# ------------------------ KMS Encryption Module Variables ------------------------
kms_description            = "KMS key for encrypting Kinesis and S3"
kms_alias_name             = "alias/logs-kms-key"
kms_deletion_window        = 10
kms_enable_rotation        = true

# ------------------------ CloudWatch Logs Destination Role Variables ------------------------
source_account_ids = [
  "123456789012",
  "234567890123",
  "345678901234",
  "987654321098",
  "162435093709"
]
destination_account_id     = "639694136535"
prefix                     = "infosec"
region                     = "us-east-1"

# ------------------------ CloudWatch Logs Destination Module Variables ------------------------

cloudwatch_destination_name_filtered = "waf-logs-destination-filtered"
cloudwatch_destination_name_unfiltered = "waf-logs-destination-unfiltered"


# ------------------------ Kinesis Firehose (Filtered) Module Variables ------------------------
filtered_firehose_name            = "firehose-to-s3-filtered"
iam_name_prefix                  = "kinesis-firehose-logs-"

# ------------------------ Kinesis Firehose (Unfiltered) Module Variables ------------------------
kinesis_firehose_unfiltered_name      = "firehose-to-s3-unfiltered"  
unfiltered_bucket_arn                 = "arn:aws:s3:::unfiltered-waf-logs-bucket"  # ARN of the S3 bucket for unfiltered Firehose logs

# ------------------------ Kinesis Firehose S3 Logs Module Variables ------------------------
kinesis_s3_bucket_name          = "curated-transformed-waf-logs-infosec"
kinesis_s3_versioning_enabled   = true
lifecycle_enabled               = true
expiration_days                 = 90

# ------------------------ Athena Module Variables ------------------------
athena_workgroup_name                  = "waf-logs-workgroup"
athena_enforce_workgroup_configuration = true
athena_prefix                          = "athena"
s3_output_location                     = "s3://athena-query-results-639694136535/"

# ------------------------ Athena S3 Results Bucket Module Variables ------------------------
athena_s3_results_bucket_name = "athena-query-results-639694136535"
athena_enable_versioning      = true

# ------------------------ Glue Crawler Module Variables ------------------------
glue_database_name            = "glue-athena-waf-logs-database"
glue_crawler_name             = "waf-logs-crawler"
glue_crawler_schedule         = "cron(0 0 * * ? *)"
glue_table_prefix             = "waf"
glue_prefix                   = "waf"
glue_crawler_description      = "Crawler for logging WAF data"

# ------------------------ Global Tags ------------------------
tags = {
  Environment = "dev"
  Owner       = "infosec-team"
}
