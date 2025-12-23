terraform {
  backend "s3" {
    bucket = "banking-app-bucket1"
    key    = "production/terraform.tfstate"
    region = "us-east-1"
  }
}