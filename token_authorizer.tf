resource "aws_iam_role" "lambda_token_execution_role" {
  name = "lambda_token_execution_role"

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

resource "aws_lambda_function" "token_authorizer" {
  function_name = "token_authorizer"
  filename      = "lambda/token-authorizer.zip"
  role          = aws_iam_role.lambda_token_execution_role.arn
  handler       = "token_authorizer.handler"
  runtime       = "nodejs12.x"
}