terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
  }

  backend "remote" {
    organization = "brambles"
    
    workspaces {
      name = "gh-actions-demo"
    }
  }
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name       = "GameScor"
  billing_mode    = "PROVISIONED"
  read_capacity     = var.read_capacity
  write_capacity = 10
  hash_key       = "UserId"
  range_key      = "GameTitle"

  attribute   {
  name         = "UserId"
    type     = "S"
  }

  attribute {
    name   = "GameTitle"
    type =    "S"
  }

  attribute {
    name = "TopScore"
    type    = "N"
  }

  ttl {
    attribute_name    = "TimeToExist"
    enabled    = false
  }

  global_secondary_index {
    name                 = "GameTitleIndex"
    hash_key           = "GameTitle"
    range_key          = "TopScore"
    write_capacity       = 10
    read_capacity    = 10
    projection_type    = "INCLUDE"
    non_key_attributes    = ["UserId"]
  
  }

   lifecycle {
        ignore_changes   = [ billing_mode, read_capacity, write_capacity ]
    }

  tags = {
    Name    = "dynamodb-table-1"
    Environment = "production"
  }
}
