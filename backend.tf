terraform {
  required_version = ">=0.12.0"
  backend "s3" {
    key     = "terraformstate/myterraform.tfstate"
    bucket = "mbikops"
    region = "us-east-1"
    #dynamodb_table = "terraform-locks"
  }
}