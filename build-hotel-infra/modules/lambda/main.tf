# resource "aws_iam_role" "lambda_role" {
#   name = "lambda-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         Service = "lambda.amazonaws.com"
#       }
#       Action = "sts:AssumeRole"
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "basic" {
#   role       = aws_iam_role.lambda_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }

# resource "aws_lambda_function" "lambda" {
#   function_name = var.function_name
#   role          = aws_iam_role.lambda_role.arn

#   handler = "index.handler"
#   runtime = "nodejs18.x"

#   filename         = "lambda.zip"
#   source_code_hash = filebase64sha256("lambda.zip")

#   environment {
#     variables = {
#       TABLE_NAME = var.dynamodb_table
#     }
#   }
# }


# 2. Local Variables
# locals {
#   function_name = "Add-Hotel"
# }

# 3. Automate .NET Build and Publish via local-exec
# resource "null_resource" "build_dotnet_lambda" {
#   triggers = {
#     always_run = timestamp() # Ensures it recompiles every time you apply
#   }

#   provisioner "local-exec" {
#     command     = "dotnet publish -c Release --runtime linux-x64 --self-contained false"
#     working_dir = local.src_dir
#   }
# }

# 4. Zip the published files
# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   source_dir  = local.publish_dir
#   output_path = local.output_zip

#   depends_on = [null_resource.build_dotnet_lambda]
# }

# 5. IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.function_name}-role"

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

# 6. Attach Basic Execution Policy for CloudWatch Logs
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "hoteladmin" {
  function_name = var.function_name
  role          = aws_iam_role.lambda_role.arn
  runtime       = "dotnet10"
  timeout       = 15
  memory_size   = 256
  handler       = "HotelMan_HotelAdmin::HotelMan_HotelAdmin.HotelAdmin::AddHotel"

  # Artifact from S3
  s3_bucket = "my-lambda-artifacts-bucket"
  s3_key    = "lambda/hoteladmin-lambda.zip"

  environment {
    variables = {
      AWS_REGION  = var.region
      bucketName  = var.bucket_name
      snsTopicArn = var.sns_topic
    }
  }
}
