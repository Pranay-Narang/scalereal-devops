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

resource "aws_api_gateway_authorizer" "lambda_auth" {
  name                   = "lambda_auth"
  rest_api_id            = aws_api_gateway_rest_api.CRUD_gateway.id
  authorizer_uri         = aws_lambda_function.token_authorizer.invoke_arn
  authorizer_credentials = aws_iam_role.gateway_invocation_role.arn
  identity_source = "method.request.header.authorizationToken"
}

resource "aws_iam_role" "gateway_invocation_role" {
  name = "gateway_invocation_role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "gateway_invocation_policy" {
  name = "gateway_invocation_policy"
  role = aws_iam_role.gateway_invocation_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "lambda:InvokeFunction",
      "Effect": "Allow",
      "Resource": "${aws_lambda_function.token_authorizer.arn}"
    }
  ]
}
EOF
}
