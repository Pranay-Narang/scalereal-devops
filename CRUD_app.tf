resource "aws_iam_role" "lambda_CRUD_execution_role" {
  name = "lambda_CRUD_execution_role"

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

resource "aws_iam_policy" "dynamodb_access_policy" {
    name = "dynamodb_access_policy"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "dynamodb:*",
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "dynamodb_access_policy_attachment" {
    roles = [ aws_iam_role.lambda_CRUD_execution_role.name ]
    policy_arn = aws_iam_policy.dynamodb_access_policy.arn

    name = "dynamodb_policy_attachment"
}

resource "aws_lambda_function" "CRUD_app" {
  function_name = "CRUD_app"
  filename      = "lambda/artifacts/CRUD-app.zip"
  role          = aws_iam_role.lambda_CRUD_execution_role.arn
  handler       = "CRUD_dynamodb.handler"
  runtime       = "nodejs12.x"
}