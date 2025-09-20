resource "aws_dynamodb_table" "carts" {
  name         = "${var.project_name}-carts"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_id"
  range_key    = "cart_id"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "cart_id"
    type = "S"
  }

  tags = {
    Name    = "${var.project_name}-carts"
    Project = var.project_name
  }
}

resource "aws_dynamodb_table" "sessions" {
  name         = "${var.project_name}-sessions"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "session_id"

  attribute {
    name = "session_id"
    type = "S"
  }

  tags = {
    Name    = "${var.project_name}-sessions"
    Project = var.project_name
  }
}
