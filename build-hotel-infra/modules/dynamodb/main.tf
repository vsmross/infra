# resource "aws_dynamodb_table" "table" {
#   name         = var.table_name
#   billing_mode = "PAY_PER_REQUEST"

#   hash_key = "id"

#   attribute {
#     name = "id"
#     type = "S"
#   }
# }

resource "aws_dynamodb_table" "table" {
  name         = "Hotels"
  billing_mode = "PAY_PER_REQUEST"

  # Primary Key
  hash_key  = "userid"
  range_key = "id"

  attribute {
    name = "userid"
    type = "S"   # String
  }

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Environment = "dev"
    Project     = "HotelApp"
  }
}