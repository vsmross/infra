# variable "instance_type" {}
# variable "key_name" {}
variable "hotel_photo_bucket_name" {
  default     = "hotel-app-hotel-photo-bucket"
  type        = string
  description = "Name of the S3 bucket in which photos of hotel are stored"
}
variable "unique_number" {}
variable "environment" {}
variable "region" {}