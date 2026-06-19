resource "aws_cognito_user_pool" "hotel_pool" {
  name = "Hotel-booking-users"

  auto_verified_attributes = ["email"]

  # ---------- REQUIRED ATTRIBUTES ----------
  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = true
    mutable             = true
  }

  schema {
    name                = "given_name"
    attribute_data_type = "String"
    required            = true
    mutable             = true
  }

  schema {
    name                = "family_name"
    attribute_data_type = "String"
    required            = true
    mutable             = true
  }

  schema {
    name                = "address"
    attribute_data_type = "String"
    required            = true
    mutable             = true
  }

  # Password policy
  password_policy {
    minimum_length    = 8
    require_uppercase = true
    require_numbers   = true
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  tags = {
    Project = "HotelApp"
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name         = "hotel-app-client"
  user_pool_id = aws_cognito_user_pool.hotel_pool.id

  generate_secret = false

  # CALLBACK / RETURN URL
  callback_urls = [
    "http://localhost:8080/hotel"
  ]

  logout_urls = [
    "http://localhost:8080/hotel"
  ]

  allowed_oauth_flows_user_pool_client = true

  allowed_oauth_flows = [
    "code"
  ]

  allowed_oauth_scopes = [
    "email",
    "openid",
    "profile"
  ]

  supported_identity_providers = [
    "COGNITO"
  ]
}