terraform {
  backend "s3" {
    bucket         = "terraform-s3-backend-tws-hackat"
    key            = "backend-locking"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
