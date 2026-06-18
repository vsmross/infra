output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "api_url" {
  value = module.apigateway.api_url
}

output "dynamodb_table" {
  value = module.dynamodb.table_name
}