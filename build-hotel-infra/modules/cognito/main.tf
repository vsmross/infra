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
    Environment = var.environment
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

  # Enable OAuth
  allowed_oauth_flows_user_pool_client = true

  # IMPlicit Grant Flow
  allowed_oauth_flows = [
    "implicit"
  ]

  # Scopes
  allowed_oauth_scopes = [
    "email",
    "openid",
    "profile"
  ]

  supported_identity_providers = [
    "COGNITO"
  ]
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain       = "hotel-app-auth-120888-${var.environment}" # must be globally unique
  user_pool_id = aws_cognito_user_pool.hotel_pool.id
}

# ---------------- USERS ----------------

# resource "aws_cognito_user" "admin" {
#   user_pool_id = aws_cognito_user_pool.hotel_pool.id
#   username     = "admin@mydomain.com"

#   attributes = {
#     email          = "admin@mydomain.com"
#     email_verified = "true"
#   }

#   temporary_password = var.user_temp_pwd
# }

# resource "aws_cognito_user" "manager" {
#   user_pool_id = aws_cognito_user_pool.hotel_pool.id
#   username     = "hmanager@mydomain.com"

#   attributes = {
#     email          = "hmanager@mydomain.com"
#     email_verified = "true"
#   }

#   temporary_password = var.user_temp_pwd
# }

# resource "aws_cognito_user" "buser" {
#   user_pool_id = aws_cognito_user_pool.hotel_pool.id
#   username     = "buser1@mydomain.com"

#   attributes = {
#     email          = "buser1@mydomain.com"
#     email_verified = "true"
#   }

#   temporary_password = var.user_temp_pwd
# }

# resource "aws_cognito_user" "guest" {
#   user_pool_id = aws_cognito_user_pool.hotel_pool.id
#   username     = "guest1@mydomain.com"

#   attributes = {
#     email          = "guest1@mydomain.com"
#     email_verified = "true"
#   }

#   temporary_password = var.user_temp_pwd
# }

# locals {
#   users = [
#     "admin@mydomain.com",
#     "hmanager@mydomain.com",
#     "buser1@mydomain.com",
#     "guest1@mydomain.com"
#   ]
# }

# resource "aws_cognito_user" "users" {
#   for_each = toset(local.users)

#   user_pool_id = aws_cognito_user_pool.hotel_pool.id
#   username     = each.value

#   attributes = {
#     email          = each.value
#     email_verified = "true"
#     given_name     = "Test"
#     family_name    = "User"
#     address        = "Pune, India"
#   }

#   temporary_password = "TempPass@123"
# }

locals {
  user_group_map = {
    "admin@mydomain.com"    = "admin"
    "hmanager@mydomain.com" = "manager"
    "guest1@mydomain.com"   = "guest"
  }
}

# ---------------- USERS ----------------

resource "aws_cognito_user" "users" {
  for_each = local.user_group_map

  user_pool_id = aws_cognito_user_pool.hotel_pool.id
  username     = each.key

  attributes = {
    email          = each.key
    email_verified = "true"
    given_name     = "Test"
    family_name    = "User"
    address        = "Pune, India"
  }

  temporary_password = var.user_temp_pwd
}

# ---------------- GROUPS ----------------

resource "aws_cognito_user_group" "admin_group" {
  name         = "admin"
  user_pool_id = aws_cognito_user_pool.hotel_pool.id
  description  = "Admin users"
}

resource "aws_cognito_user_group" "manager_group" {
  name         = "manager"
  user_pool_id = aws_cognito_user_pool.hotel_pool.id
  description  = "Manager users"
}

resource "aws_cognito_user_group" "guest_group" {
  name         = "guest"
  user_pool_id = aws_cognito_user_pool.hotel_pool.id
  description  = "Guest users"
}

# ---------------- GROUPS Assignments ----------------

resource "aws_cognito_user_in_group" "assignments" {
  for_each = local.user_group_map

  user_pool_id = aws_cognito_user_pool.hotel_pool.id
  username     = each.key
  group_name   = each.value
}