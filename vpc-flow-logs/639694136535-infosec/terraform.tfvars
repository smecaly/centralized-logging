# ------------------------ KMS Encryption Module Variables ------------------------
kms_description            = "KMS key for encrypting Kinesis and S3"
kms_alias_name             = "alias/vpc-flow-logs-kms-key"
kms_deletion_window        = 10
kms_enable_rotation        = true

# ------------------------ CloudWatch Logs Destination Module Variables ------------------------
source_account_ids = [
  "123456789012",
  "234567890123",
  "345678901234",
  "987654321098",
  "162435093709"
]
destination_account_id     = "639694136535"
cloudwatch_destination_name = "vpc-logs-destination"
region                     = "us-east-1"

# ------------------------ Kinesis Firehose Module Variables ------------------------
kinesis_firehose_name            = "vpc-flow-logs-firehose"
kinesis_firehose_iam_prefix      = "flow-logs"
function_name = "flow-logs-transformation-lambda"
kinesis_cloudwatch_log_group_name = "vpc-firehose-error-logs"
kinesis_cloudwatch_log_stream_name = "vpc-firehose-error-log-stream"
vpc_cidr_ranges   = ["10.0.0.0/16", "192.168.0.0/16","172.31.0.0/16","10.247.0.0/16"] 

# ------------------------ Kinesis Firehose S3 Logs Module Variables ------------------------
kinesis_s3_bucket_name      = "curated-transformed-vpc--flow-logs-infosec"
kinesis_s3_versioning_enabled = true
lifecycle_enabled   = true
expiration_days     = 90

# ------------------------ Glue Crawler Module Variables ------------------------
glue_database_name            = "glue-athena-vpc-logs-database"
glue_crawler_name             = "vpc-logs-crawler"
glue_crawler_schedule         = "cron(0 0 * * ? *)"
glue_table_prefix             = "consolidated-vpc"
glue_prefix                   = "consolidated-vpc"
glue_crawler_description      = "Crawler for logging vpc data"
classifiers                   = []  # Optional, can add classifier ARNs here if needed
configuration                 = ""  # Optional, any custom configuration for the crawler

# ------------------------ Athena Module Variables ------------------------
athena_workgroup_name                  = "vpc-logs-workgroup-filtered"
athena_enforce_workgroup_configuration = true
athena_prefix                          = "vpc-logs"
s3_output_location                     = "s3://vpc-athena-query-results-639694136535/"

# ------------------------ Athena S3 Results Bucket Module Variables ------------------------
athena_s3_results_bucket_name = "vpc-athena-query-results-639694136535"
athena_enable_versioning      = true

# ------------------------ Global Tags ------------------------
tags = {
  Environment = "dev"
  Owner       = "infosec-team"
}
