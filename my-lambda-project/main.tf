# --- 1. TERRAFORM & PROVIDER CONFIGURATION ---
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Change to your preferred AWS region
}

# --- 2. IAM ROLE & POLICIES FOR LAMBDA ---
# Create the execution role that Lambda assumes
resource "aws_iam_role" "lambda_role" {
  name = "my_lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach basic execution policy to allow CloudWatch logging
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# --- 3. SOURCE CODE ARCHIVING ---
# Automatically ZIP the 'src' directory before deployment
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/bin/lambda.zip"
}

# --- 4. LAMBDA FUNCTION RESOURCE ---
resource "aws_lambda_function" "my_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  
  function_name    = "my-terraform-lambda"
  role             = aws_iam_role.lambda_role.arn
  runtime          = "python3.12"
  handler          = "index.handler" # Matches file name (index.py) and function name (handler)
  
  timeout          = 10
  memory_size      = 128

  # Optional environment variables
  environment {
    variables = {
      ENV_NAME = "production"
    }
  }

  # Ensure role policy is attached before the function is built
  depends_on = [aws_iam_role_policy_attachment.lambda_logs]
}

# --- 5. CLOUDWATCH LOG GROUP ---
# Explicitly managing the log group ensures logs are cleaned up on terraform destroy
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.my_lambda.function_name}"
  retention_in_days = 7
}
