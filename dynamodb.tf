resource "aws_dynamodb_table" "CSVWrite" {
    name = "CSVWrite"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "id"
    
    attribute {
        name = "id"
        type = "N"
    }
}
