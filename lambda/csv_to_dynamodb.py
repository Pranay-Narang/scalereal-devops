import json
import boto3
import csv
import codecs
import sys

s3 = boto3.resource('s3')
dynamodb = boto3.resource('dynamodb')

def lambda_handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        csvObj = s3.Object(bucket, key).get()['Body']
        
        batch_size = 100
        batch = []
        
        for row in csv.DictReader(codecs.getreader('utf-8')(csvObj)):
            if len(batch) >= batch_size:
                writeDynamoDBTable(batch)
                batch.clear()
                
            batch.append(row)
        
        if batch:
            writeDynamoDBTable(batch)
    
    return {
        'statusCode': 200,
        'body': json.dumps('CSV Converted and pushed to DynamoDB')
    }
    
def writeDynamoDBTable(rows):
    table = dynamodb.Table('CSVWrite')
    with table.batch_writer() as batch:
        for i in range(len(rows)):
            batch.put_item(Item=rows[i])