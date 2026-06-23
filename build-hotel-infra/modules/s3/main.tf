resource "aws_s3_bucket" "hote_photo_bucket" {
  bucket = "${var.hotel_photo_bucket_name}-${var.unique_number}" # must be globally unique

  tags = {
    Project     = "HotelApp"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_policy" "lambda_access" {
  bucket = aws_s3_bucket.hote_photo_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEveryoneReadOnlyAccess"
        Effect = "Allow"

        Principal = {
          AWS = "*"
        }

        Action = [
          "s3:ListBucket"
        ]

        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.hote_photo_bucket.name}/*" # objects
        ]
      },
      {
        Sid    = "AllowLambdaWriteAccess"
        Effect = "Allow"

        Principal = {
          AWS = aws_iam_role.hotel_admin_lambda_role.arn # Lambda role ARN
        }

        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion"
        ]

        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.hote_photo_bucket.name}/*"
        ]
      }
    ]
  })
}