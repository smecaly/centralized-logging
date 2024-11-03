##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

resource "aws_lambda_function" "data_transformer" {
  function_name = var.function_name
  handler       = "lambda.lambda_handler"
  role          = aws_iam_role.lambda_exec.arn
  runtime       = "python3.9"
  timeout       = var.lambda_timeout

  filename         = "${path.module}/lambda_function.zip"
  source_code_hash = data.archive_file.lambda.output_base64sha256

  # Environment variables
  environment {
    variables = {
      VPC_CIDR_RANGES = join(",", var.vpc_cidr_ranges)
    }
  }

  tags = var.tags
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda.py"
  output_path = "${path.module}/lambda_function.zip"
}
