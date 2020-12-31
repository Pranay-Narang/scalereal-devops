resource "aws_iam_role" "lambda_iam_role" {
  name = "csv-scanner-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "dynamodb_and_s3_access_policy" {
    name = "dynamodb_and_s3_access_policy"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "dynamodb:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "dynamodb_and_s3_access_policy_attachment" {
    roles = [ aws_iam_role.lambda_iam_role.name ]
    policy_arn = aws_iam_policy.dynamodb_and_s3_access_policy.arn

    name = "dynamodb_policy_attachment"
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.csv_scanner.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.csv_store_lambda.arn
}

resource "aws_lambda_function" "csv_scanner" {
  function_name = "csv_scanner"
  filename      = "lambda/artifacts/csv-scanner.zip"
  role          = aws_iam_role.lambda_iam_role.arn
  handler       = "csv_to_dynamodb.lambda_handler"
  runtime       = "python3.8"
}

resource "aws_s3_bucket_notification" "upload_trigger" {
  bucket = aws_s3_bucket.csv_store_lambda.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.csv_scanner.arn
    events              = ["s3:ObjectCreated:*"]
  }
}
