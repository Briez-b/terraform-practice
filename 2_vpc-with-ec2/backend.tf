terraform {
  backend "s3" {
    bucket = "terr-vpc-bucket"
    key = "state/terraform.tfstate"
    region = "eu-central-1"
    encrypt = true
    dynamodb_table = "terr-vpc-table"
  }
}