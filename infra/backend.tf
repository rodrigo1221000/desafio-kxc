terraform {
  backend "s3" {
    bucket  = "rodrigo-gomes-tfstate"
    key     = "main/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}