# IAM Role for Lambda


# IAM Role for Lambda
resource "aws_iam_role" "hotel_admin_lambda_role" {
  name = "${var.function_name}-Lambda-ExecutionRole"

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

  tags = {
    Project = "HotelApp"
  }
}

# Attach AWSLambdaBasicExecutionRole
resource "aws_iam_role_policy_attachment" "basic_execution" {
  role       = aws_iam_role.hotel_admin_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach AWSLambdaExecute
resource "aws_iam_role_policy_attachment" "lambda_execute" {
  role       = aws_iam_role.hotel_admin_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

# Attach DynamoDB Full Access
resource "aws_iam_role_policy_attachment" "dynamodb_access" {
  role       = aws_iam_role.hotel_admin_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}


resource "aws_lambda_function" "hoteladmin" {
  function_name = "${var.function_name}-${var.environment}"
  role          = aws_iam_role.hotel_admin_lambda_role.arn
  runtime       = "dotnet10"
  timeout       = 15
  memory_size   = 256
  handler       = "HotelMan_HotelAdmin::HotelMan_HotelAdmin.HotelAdmin::AddHotel"

  # Artifact from S3
  s3_bucket = "hotel-lambda-artifacts-bucket"
  s3_key    = "lambda/hoteladmin-lambda.zip"

  environment {
    variables = {
      bucketName  = var.bucket_name
      snsTopicArn = var.sns_topic
    }
  }
}
