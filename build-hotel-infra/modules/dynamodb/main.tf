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
    type = "S" # String
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

# --------------------- Seed Data ----------------------
locals {
  hotels = {
    hotel1 = {
      userid   = "user1"
      id       = "hotel1"
      Name     = "Taj Palace"
      Price    = 5000
      Rating   = 5
      CityName = "Mumbai"
      FileName = "taj.jpg"
    },
    hotel2 = {
      userid   = "user2"
      id       = "hotel2"
      Name     = "Oberoi"
      Price    = 7000
      Rating   = 5
      CityName = "Delhi"
      FileName = "oberoi.jpg"
    },
    hotel3 = {
      userid   = "user3"
      id       = "hotel3"
      Name     = "ITC Grand"
      Price    = 4500
      Rating   = 4
      CityName = "Bangalore"
      FileName = "itc.jpg"
    }
  }
}

resource "aws_dynamodb_table_item" "hotels" {
  for_each   = local.hotels
  table_name = "Hotels"
  hash_key   = "userid"
  range_key  = "id"

  item = jsonencode({
    userid   = { S = each.value.userid }
    id       = { S = each.value.id }
    Name     = { S = each.value.Name }
    Price    = { N = tostring(each.value.Price) }
    Rating   = { N = tostring(each.value.Rating) }
    CityName = { S = each.value.CityName }
    FileName = { S = each.value.FileName }
  })
}