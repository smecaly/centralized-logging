# ------------------------ KMS Encryption Module Variables ------------------------
kms_description            = "KMS key for encrypting Kinesis and S3"
kms_alias_name             = "alias/logs-kms-key"
kms_deletion_window        = 10
kms_enable_rotation        = true

# ------------------------ S3 Unfiltered WAF Logs Module Variables ------------------------
waf_logs_bucket_name       = "unfiltered-waf-logs-bucket"
versioning_enabled         = false
# sse_algorithm              = "aws:kms"
lifecycle_enabled          = true
expiration_days            = 60
kinesis_firehose_role_arn  = "arn:aws:iam::639694136535:role/kinesis-firehose-role"
logging_account_id         = "162435093709"
infosec_account_id         = "639694136535"

# ------------------------ Glue Crawler Module Variables ------------------------
database_name_unfiltered   = "glue-athena-waf-logs-database"
crawler_name               = "waf-logs-crawler"
schedule_unfiltered        = "cron(0 0 * * ? *)"
prefix                     = "waf"
crawler_description        = "Crawler for logging WAF data"
configuration_unfiltered   = ""

# ------------------------ Athena Module Variables ------------------------
athena_workgroup_name                  = "waf-logs-workgroup"
s3_output_location                     = "s3://athena-query-results-162435093709/"
athena_enforce_workgroup_configuration = true
athena_prefix                          = "athena"

# ------------------------ Athena S3 Query Results Bucket Module Variables ------------------------
athena_s3_results_bucket_name = "athena-query-results-162435093709"
athena_enable_versioning      = true

# ------------------------ Global Tags ------------------------
tags = {
  Environment = "dev"
  Owner       = "infosec-team"
}
