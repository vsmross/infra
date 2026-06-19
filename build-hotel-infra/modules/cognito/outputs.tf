output "user_pool_name" {
  value = aws_cognito_user_pool.hotel_pool.name
}

output "user_pool_id" {
  description = "Cognito User Pool ID"
  value       = aws_cognito_user_pool.hotel_pool.id
}

# output "user_pool_domain" {
#     description = "Cognito User Pool Domain"
#     value       = aws_cognito_user_pool.domain.name
# }

output "client_id" {
  description = "Cognito App Client ID"
  value       = aws_cognito_user_pool_client.client.id
}

output "cognito_domain" {
  description = "Cognito Hosted UI Domain"
  value       = aws_cognito_user_pool.hotel_pool.domain
}

output "cognito_login_url" {
  description = "Cognito Hosted UI Login URL"
  value = "https://${aws_cognito_user_pool.hotel_pool.domain}.auth.${var.region}.amazoncognito.com/login"
}