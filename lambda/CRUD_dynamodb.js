const AWS = require("aws-sdk");
const documentClient = new AWS.DynamoDB.DocumentClient();

const tableName = "CSVWrite";

exports.handler = async (event) => {
    const requestMethod = event['requestContext']['httpMethod'];

    if (requestMethod == "GET") {
        const params = {
            TableName: tableName
        };

        const data = await documentClient.scan(params).promise();

        const response = {
            statusCode: 200,
            body: JSON.stringify(data.Items)
        };
        return response;

    }
};