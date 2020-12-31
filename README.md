# ScaleReal DevOps Assignment

## Prerequisites

### Packages needed
- `terraform`

### Remote backend (S3)
- Uses `remote-tf-state` bucket (Can be changed in [main.tf](main.tf))

## Build

- ### Initialize Keys
```bash
$ export AWS_ACCESS_KEY_ID=<access_key> [Required]
$ export AWS_SECRET_ACCESS_KEY=<secret_key> [Required]
$ export AWS_SESSION_TOKEN=<session_token> [If Applicable]
```

- ### View Changes
```bash
$ terraform plan
```

- ### Bring up infrasturcture
```bash
$ terraform apply
```

## Verify
- The above command will print out the API Gateway endpoint like below
```bash
Outputs:

API_Gateway_URL = "https://<api_gateway_id>.execute-api.us-east-1.amazonaws.com/<stage_name>"
```

## Test
- ### CRUD
    - Use [this](https://pranay.wtf/scalereal/ScaleReal_DevOps.postman_collection.json) Postman collection to test the CRUD operations
    - Create an environment in Postman with the following variables
        - `host` - Pointing to API Gateway endpoint (excluding the stage name)
- ### CSV Lambda Function
    - Upload [this](https://pranay.wtf/scalereal/lambda-test.csv) CSV file into the S3 bucket named `csv-store-lambda`
    - Use the `GET` operation on API Gateway URL to verify

## Authentication
- Uses a simple Lambda function which checks for the following header
    - `authorizationToken`
- Based on the value passed in the header it generates an IAM policy to allow or deny the request
- Following are the accepted values for the header
    - `allow`
    - `deny`
    - `unauthorized`
- This can be enhanced by including a more secure authentication and authorization mechanism which generates real JWT tokens and verifies them from a token store