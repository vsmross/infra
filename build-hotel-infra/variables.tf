variable "region" {
  type        = string
  description = "Aws region for this deploypment"
  default     = "us-east-2"
}

variable "environment" {}
variable "lambda_bucket" {}
variable "state_bucket" {}
variable "app_unique_number" {}

# variable "devInstanceName" {
#   type        = string
#   description = "dev-app-01"
#   default     = "dev-app-01"
# }

# variable "key_name" {
#   description = "EC2 Key pair name"
# }


