# Define Terraform backend using a S3 bucket for storing the Terraform state
terraform {
  backend "s3" {}
}