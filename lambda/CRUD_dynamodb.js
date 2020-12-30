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

    } else if (requestMethod == "POST") {
        var { id, name, age } = JSON.parse(event.body)

        const params = {
            TableName: tableName,
            Item: {
                id: id,
                name: name,
                age: age
            }
        };

        const data = await documentClient.put(params).promise();

        const response = {
            statusCode: 200,
            body: "Item Added Successfully"
        }
        return response;
    }
};