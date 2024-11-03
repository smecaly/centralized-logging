# ------------------------ S3 Bucket Module Variables ------------------------
bucket_name         = "s3-flow-logs-infosec"
versioning_enabled  = false
lifecycle_enabled   = true
expiration_days     = 60
source_account_ids = ["162435093709", "234567890123", "345678901234"]


# ------------------------ Glue Crawler Module Variables ------------------------
database_name_unfiltered   = "glue-flow-logs-database"
crawler_name               = "flow-logs-crawler"
schedule_unfiltered        = "cron(0 12 * * ? *)"
prefix                     = "flow-logs"
crawler_description        = "Crawler for processing flow logs"
configuration_unfiltered   = ""

# ------------------------ Athena Module Variables ------------------------
athena_workgroup_name                  = "flow-logs-workgroup-unfiltered"
s3_output_location                     = "s3://athena-query-results-639694136535"
athena_enforce_workgroup_configuration = true
athena_prefix                          = "flowlogs"

# ------------------------ Global Variables ------------------------
tags = {
  Environment = "dev"
  Project     = "Centralized Logging"
}

kms_key_arn = "arn:aws:kms:us-east-1:639694136535:key/afe9c09a-931c-4a11-8ae5-dba9a9d3404c"
