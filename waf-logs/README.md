                               # Centralized Logging Deployment and Testing Guide for AWS WAF Logs
                                
This guide provides instructions to deploy and test a WAF logging solution across Infosec Tooling and Division accounts, centralizing WAF logs for analysis in Athena.

Overview
This setup enables the collection, transformation, and querying of WAF logs across multiple accounts. The solution utilizes Kinesis Firehose in the Infosec account to filter and deliver logs to S3 buckets in the Logging account, where they can be queried using Athena. Additionally, Glue Crawlers are used to catalog log data in the Glue Data Catalog for use in Athena.

                                      Project Directory Structure

Logging Account:
Contains resources specific to the logging account, such as the S3 buckets for Athena query results and the unfiltered WAF logs, along with modules for Athena, Glue Crawler, and KMS.

.
├── main.tf
├── modules
│   ├── athena
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── glue-crawler
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── kms
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── s3-athena-query-results
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   └── s3-unfiltered-waf
│       ├── main.tf
│       ├── output.tf
│       └── varialbes.tf
├── output.tf
├── terraform.tfvars
└── variables.tf

Infosec Tooling Account: Centralizes resources for the infosec account, including Kinesis Firehose configurations for filtered/unfiltered logs, and CloudWatch log destination settings.

├── main.tf
├── modules
│   ├── athena
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── cloudwatch_destination
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── role.tf
│   │   └── variables.tf
│   ├── glue-crawler
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── kinesis-firehose-filtered
│   │   ├── cloudwatch.tf
│   │   ├── iam.tf
│   │   ├── lambda.py
│   │   ├── lambda.tf
│   │   ├── lambda_function.zip
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── kinesis-firehose-unfiltered
│   │   ├── cloudwatch.tf
│   │   ├── iam.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── kms
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── s3-athena-query-results
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   └── s3-kinesis-curated
│       ├── main.tf
│       ├── output.tf
│       └── varialbes.tf
├── output.tf
├── terraform.tfvars
└── variables.tf

Division Member Accounts: Holds configurations and modules for member accounts, primarily focused on enabling WAF logging, creating CloudWatch log groups, and establishing subscriptions.

├── main.tf
├── modules
│   ├── cloudwatch-log-group
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   └── enable-logging-waf
│       ├── main.tf
│       └── variables.tf
├── terraform.tfvars
└── variable.tf


## Deployment Steps

1. Logging Account Deployment (Primary Data Storage)
The Logging account will host the primary S3 buckets for unfiltered WAF logs and Athena query results. Additionally, Glue Crawlers and Athena are configured here.

### Steps:

- Configure terraform.tfvars: Update variables in the terraform.tfvars file for the Logging account, particularly the following:

Bucket Names: Set names for unfiltered WAF logs bucket and Athena query results bucket.
KMS Configuration: Define encryption settings.
Glue Crawler and Athena: Set names and any necessary schedules for Glue Crawlers and Athena workgroups.

- Initialize and Deploy:


terraform init
terraform plan
terraform apply -auto-approve
This command will deploy the required S3 buckets, KMS keys, Glue Crawlers, and Athena workgroups.

Outputs: Note the outputs from the deployment, particularly the S3 bucket ARNs and KMS key ARN, which will be needed for cross-account access in the Infosec account.

2. Infosec Tooling Account Deployment (Central Processing and Transformation)
The Infosec Tooling account handles log filtering and forwarding to the Logging account’s S3 bucket via Kinesis. This account also holds IAM roles to allow cross-account access from the Division Member accounts.

### Steps:

- Configure terraform.tfvars: Update variables, including:

Kinesis Firehose Configuration: Set names for the Firehose delivery streams (filtered and unfiltered) and specify the IAM roles needed.
S3 Target: Set the S3 bucket ARN in the Logging account for Firehose to deliver logs to.
- Initialize and Deploy:

terraform init
terraform plan
terraform apply -auto-approve

This will deploy the Kinesis Firehose streams, Lambda functions for filtering (if applicable), Glue Crawler, and CloudWatch destination configurations.

Outputs: Capture the Kinesis Firehose ARNs and IAM role ARNs required by the Division Member accounts to forward logs.

3. Division Member Accounts Deployment (Log Generation and Forwarding)
Each Division Member account will enable WAF logging on all WebACLs configure CloudWatch log groups and set up the necessary subscriptions to forward WAF logs to the Kinesis Firehose in the Infosec Tooling account.

### Steps:

- Configure terraform.tfvars: Specify the following in each Division account:

CloudWatch Log Group Names: Define the names for WAF CloudWatch log groups.
Kinesis Destination: Use the Kinesis Firehose ARN from the Infosec Tooling account as the destination for log subscriptions.
- Initialize and Deploy:

terraform init
terraform plan
terraform apply -auto-approve
This command deploys CloudWatch log groups and configures the WAF log subscriptions to forward to the Infosec Tooling account.

## Testing and Validation
1. Generate WAF Logs
Simulate web traffic in each Division Member account to trigger WAF logs. Confirm logs are visible in the CloudWatch log groups created during deployment.
2. Validate Log Forwarding to Kinesis Firehose
In the Infosec Tooling account, check that Kinesis Firehose is receiving logs from the Division Member accounts.
Ensure both filtered and unfiltered logs are delivered to the correct S3 buckets (filtered in the Infosec S3 bucket and unfiltered in the Logging account's S3 bucket).
3. Run Glue Crawler in the Logging Account
Manually trigger the Glue Crawler to process the new logs.
Verify that the crawler successfully catalogs logs in the Glue Data Catalog, creating or updating tables and partitions as necessary.
Ensure that the crawler excludes any folders specified in the exclusions configuration (e.g., processing-failed).
4. Validate Athena Tables and Query Logs
In the Logging account, open Amazon Athena.
Select the workgroup and database created by the Glue Crawler.
Run queries to confirm that WAF logs are accessible and correctly structured.
Example Athena Query
To find the most frequent client IPs in WAF logs, use the following query:


SELECT  
    requestId,  
    httpRequest.clientIp,  
    httpRequest.country,  
    httpRequest.httpMethod,  
    httpRequest.uri 
FROM  
    "consolidated-waf2024" 
LIMIT 100;


More Athena queries for WAF logs can be found here https://github.com/aws-samples/waf-log-sample-athena-queries

5. Monitor and Review
Confirm the successful flow of logs from the Division Member accounts to the Logging account, validating that logs appear in both the S3 bucket and Athena tables.
Check for any errors in Kinesis, Lambda (if used), and Glue to ensure seamless operation.

