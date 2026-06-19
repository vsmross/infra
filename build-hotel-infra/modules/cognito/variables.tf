variable "user_pool_name" {}
variable "region" {}
variable "user_pool_id" {}
variable "user_pool_domain" {}
variable "client_id" {}
variable "cognito_domain" {}
variable "cognito_login_url" {}
variable "user_temp_pwd" {
  description = "Password to set at the time of user creation"
  type        = string
  default     = "Hotel@1234"
}