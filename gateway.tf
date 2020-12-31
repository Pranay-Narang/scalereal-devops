resource "aws_api_gateway_rest_api" "CRUD_gateway" {
    name = "CRUD_gateway"

    endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_method" "gateway_method" {
   rest_api_id   = aws_api_gateway_rest_api.CRUD_gateway.id
   resource_id   = aws_api_gateway_rest_api.CRUD_gateway.root_resource_id
   http_method   = "ANY"
   authorization = "CUSTOM"

   authorizer_id = aws_api_gateway_authorizer.lambda_auth.id
}

resource "aws_api_gateway_integration" "lambda_integration" {
   rest_api_id = aws_api_gateway_rest_api.CRUD_gateway.id
   resource_id = aws_api_gateway_method.gateway_method.resource_id
   http_method = aws_api_gateway_method.gateway_method.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.CRUD_app.invoke_arn
}

resource "aws_api_gateway_deployment" "prod" {
   depends_on = [
     aws_api_gateway_integration.lambda_integration,
   ]

   rest_api_id = aws_api_gateway_rest_api.CRUD_gateway.id
   stage_name  = "prod"
}

resource "aws_lambda_permission" "apigw" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.CRUD_app.function_name
   principal     = "apigateway.amazonaws.com"

   source_arn = "${aws_api_gateway_rest_api.CRUD_gateway.execution_arn}/*/*"
}

output "API_Gateway_URL" {
    value = aws_api_gateway_deployment.prod.invoke_url
}