##############################################################################################################################
# Copyright 2024 Amazon.com and its affiliates; all rights reserved. This file is Amazon Web Services Content and may not be
# duplicated or distributed without permission.
#
# Version: 1.0.0
##############################################################################################################################

resource "aws_lambda_function" "data_transformer" {
  function_name = var.function_name
  handler       = "lambda.lambda_handler"  # Ensure this matches your handler function inside lambda.py
  role          = aws_iam_role.lambda_exec.arn
  runtime       = "python3.9"
  timeout       = var.lambda_timeout

  # Reference the local zip file
  filename = "${path.module}/lambda_function.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_function.zip")

  tags = var.tags
}
