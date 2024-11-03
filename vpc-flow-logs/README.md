Centralized Logging Deployment and Testing Guide for VPC Flow Logs
This guide provides comprehensive instructions for deploying and testing a VPC flow logging solution across a central logging account, an infosec-tooling account, and member accounts, centralizing VPC flow logs for analysis.

Overview
This setup enables the collection, transformation, and querying of VPC flow logs across multiple AWS accounts. The solution routes VPC flow logs from member accounts to a centralized S3 bucket in the logging account and sends logs to CloudWatch Logs, which are then forwarded to Kinesis in the infosec account. The data is cataloged in the Glue Data Catalog for use in Athena.

Project Directory Structure
Infosec Account:
This account manages log processing, including Kinesis Firehose configurations and CloudWatch destination settings.


├── main.tf
├── modules
│   ├── athena
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── cloudwatch_destination
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── role.tf
│   │   └── variables.tf
│   ├── glue-crawler
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── kinesis-firehose
│   │   ├── cloudwatch.tf
│   │   ├── iam.tf
│   │   ├── lambda.py
│   │   ├── lambda.tf
│   │   ├── lambda_function.zip
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── kms
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── s3-athena-query-results
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   └── s3-kinesis-curated
│       ├── main.tf
│       ├── output.tf
│       └── variables.tf
├── output.tf
├── terraform.tfvars
└── variables.tf

Central Logging Account:
Contains the primary data storage resources for centralized logging, such as S3 buckets for VPC flow logs and query results, and modules for Glue Crawler and KMS.

├── main.tf
├── modules
│   ├── athena
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── glue-crawler
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── s3-flow-logs
│       ├── main.tf
│       ├── output.tf
│       └── variables.tf
├── output.tf
├── terraform.tfvars
└── variables.tf

Member Accounts:
Holds configurations for creating VPC flow logs, enabling logging, and setting up CloudWatch subscription filters.


├── main.tf
├── modules
│   └── vpc-flow-logs
│       ├── iam.tf
│       ├── main.tf
│       ├── output.tf
│       └── variables.tf
├── output.tf
├── providers.tf
├── terraform.tfstate
├── terraform.tfstate.backup
├── terraform.tfvars
└── variables.tf


Deployment Steps
1. Infosec Tooling Account Deployment (Central Processing and Transformation)
This account handles log transformation and forwarding to the S3 bucket in the logging account.

Steps:
Configure terraform.tfvars: Update variables, including:

Kinesis Firehose configuration.
KMS encryption settings.
CloudWatch destination setup.
Deploy:

bash
Copy code
terraform init
terraform plan
terraform apply -auto-approve
Outputs:
Capture Kinesis Firehose ARNs, CloudWatch Logs destination ARN, and IAM role ARNs needed by member accounts.

2. Central Logging Account Deployment (Primary Data Storage)
This account hosts the main S3 buckets for VPC flow logs and query results, Glue Crawlers, and Athena workgroups.

Steps:
Configure terraform.tfvars: Update variables for:

S3 bucket names and lifecycle policies.
KMS configuration for S3 encryption.
Glue Crawler and Athena workgroup settings.
Deploy:


terraform init
terraform plan
terraform apply -auto-approve
Outputs:
Note the S3 bucket ARNs and KMS key ARN for use in member account deployments.

3. Member Account Deployment (Log Generation and Forwarding)
Each member account creates VPC flow logs and forwards them to the S3 bucket and CloudWatch Logs.

Steps:
Configure terraform.tfvars:

Add CloudWatch log group names.
Specify S3 and CloudWatch destination ARNs obtained from the logging and infosec accounts.
Deploy:


terraform init
terraform plan
terraform apply -auto-approve
Testing and Validation
1. Generate VPC Flow Logs
Generate traffic in each VPC within the member accounts to produce logs.

2. Validate Log Forwarding
Infosec Account:
Confirm that Kinesis Firehose receives logs from member accounts.
Verify logs are delivered to the S3 bucket in the logging account.
3. Run Glue Crawler
Logging Account:
Manually trigger the Glue Crawler to update tables in the Glue Data Catalog.
Verify table creation and partitions.
4. Query Logs in Athena
Execute Athena queries:

SELECT 
    srcaddr,
    dstaddr,
    protocol,
    action,
    COUNT(*) as traffic_count
FROM "<DATABASE_NAME>"."<TABLE_NAME>"
GROUP BY 
    srcaddr, 
    dstaddr, 
    protocol, 
    action
ORDER BY traffic_count DESC
LIMIT 10;

5. Monitor and Review
Ensure logs are visible in the S3 bucket and queries return expected results.
Review error logs in Kinesis and CloudWatch for issues.