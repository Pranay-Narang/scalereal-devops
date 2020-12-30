resource "aws_s3_bucket" "csv_store_lambda" {
    bucket = "csv-store-lambda"
    acl = "private"
}