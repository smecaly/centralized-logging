
# ------------------------ CloudWatch Log Subscription Filter Names ------------------------

waf_log_group_name = "aws-waf-logs-global"
retention_in_days  = 14

filter_names = [
  "kinesis-filter-unfiltered",
  "kinesis-filter-filtered"
]

filter_patterns = [
  "",  
  ""   
]


destination_arns = [
  "arn:aws:logs:us-east-1:639694136535:destination:waf-logs-destination-unfiltered",
  "arn:aws:logs:us-east-1:639694136535:destination:waf-logs-destination-filtered"
]


# ------------------------ WAF ARNs to Enable Logging ------------------------

waf_arn = [
  "arn:aws:wafv2:us-east-1:162435093709:regional/webacl/test/33077540-1d24-402e-98c5-3faced517ae2",
  "arn:aws:wafv2:us-east-1:162435093709:regional/webacl/kinesis-fw/3451da17-c0cf-45c3-885c-b46e9678963f"
]
