
# module "ec2" {
#   source        = "./modules/ec2"
#   instance_type = "t2.micro"
#   key_name      = var.key_name
# }

module "dynamodb" {
  source      = "./modules/dynamodb"
  table_name  = "Hotels"
  environment = var.environment
}

module "cognito" {
  source            = "./modules/cognito"
  user_pool_name    = "Hotel-booking-users"
  region            = var.region
  user_pool_id      = module.cognito.user_pool_id
  client_id         = module.cognito.client_id
  cognito_domain    = module.cognito.cognito_domain
  cognito_login_url = module.cognito.cognito_login_url
  user_pool_domain  = module.cognito.user_pool_domain
  environment       = var.environment
}

module "lambda" {
  source         = "./modules/lambda"
  function_name  = "Add-Hotel"
  dynamodb_table = module.dynamodb.table_name
  region         = var.region
  bucket_name    = "test-bucket"
  sns_topic      = "sns-topic"
  environment    = var.environment
}

# module "apigateway" {
#   source        = "./modules/apigateway"
#   lambda_arn    = module.lambda.lambda_arn
# }

# # 2. Local Variables
# locals {
#   function_name = "Add-Hotel"
#   src_dir       = "${path.module}/HotelMan_HotelAdmin"
#   publish_dir   = "${path.module}/HotelMan_HotelAdmin/bin/release/net10.0/linux-x64/publish"
#   output_zip    = "${path.module}/hotel-addhotel-function.zip"
# }

# # 3. Automate .NET Build and Publish via local-exec
# resource "null_resource" "build_dotnet_lambda" {
#   triggers = {
#     always_run = timestamp() # Ensures it recompiles every time you apply
#   }

#   provisioner "local-exec" {
#     command     = "dotnet publish -c Release --runtime linux-x64 --self-contained false"
#     working_dir = local.src_dir
#   }
# }

# # 4. Zip the published files
# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   source_dir  = local.publish_dir
#   output_path = local.output_zip

#   depends_on = [null_resource.build_dotnet_lambda]
# }

# # 5. IAM Role for Lambda
# resource "aws_iam_role" "lambda_role" {
#   name = "${local.function_name}-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# # 6. Attach Basic Execution Policy for CloudWatch Logs
# resource "aws_iam_role_policy_attachment" "lambda_logs" {
#   role       = aws_iam_role.lambda_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }

# # 7. Provision the AWS Lambda Function
# resource "aws_lambda_function" "dotnet_lambda" {
#   filename         = data.archive_file.lambda_zip.output_path
#   source_code_hash = data.archive_file.lambda_zip.output_base64sha256
#   function_name    = local.function_name
#   role             = aws_iam_role.lambda_role.arn
#   runtime          = "dotnet10"
#   timeout          = 15
#   memory_size      = 256

#   # Format: AssemblyName::Namespace.ClassName::MethodName
#   handler = "HotelMan_HotelAdmin::HotelMan_HotelAdmin.HotelAdmin::AddHotel" 

#   depends_on = [
#     aws_iam_role_policy_attachment.lambda_logs,
#     data.archive_file.lambda_zip
#   ]
# }
