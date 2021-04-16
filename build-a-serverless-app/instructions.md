## PART 1 - SQS - Lambda - DynamoDB Table ##

Set region:
    Region: us-east-1

Note your AWS account number: *ACCOUNT NUMBER*

Create DDB Table:
	Name: ProductVisits
	Partition key: ProductVisitKey
	
Create SQS Queue:
	Name: ProductVisitsDataQueue
	Type: Standard
	
Note the Queue URL: *QUEUE URL*

Go to AWS Lambda and create function
	Name: productVisitsDataHandler
	Runtime: Node.js 12.x
	Role: create new role from templates
	Role name: lambdaRoleForSQSPermissions
	Add policy templates: "Simple microservice permissions" and Amazon SQS poller permissions"
	
From actions menu in front of function code heading upload a zip file (DCTProductVisitsTracking.zip)

Go back to SQS and open "ProductVisitsDataQueue"

Configure Lambda function trigger and specify Lambda function:
    Name: productVisitsDataHandler

Go to AWS CLI and send messages:
    AWS CLI Command: `aws sqs send-message --queue-url *QUEUE URL* --message-body file://message-body-1.json`
    Modify: Queue name and file name
    File location: Code/build-a-serverless-app/part-1

## PART 2 - DynamoDB Streams - Lambda - S3 Data Lake ##

Go to DDB table

Enable stream for "New Image"

Create S3 bucket in same region:
	Name: product-visits-datalake
    Modify: bucket name by adding letters/numbers at end to be unique
    Region: us-east-1

Go to IAM and create a policy:
	Name: productVisitsLoadingLambdaPolicy
	JSON: Copy contents of "lambda-policy.json"
	Modify: Replace account number / region / names as required

Account number: *ACCOUNT NUMBER*

Create a role:
	Use case: Lambda
	Policy: productVisitsLoadingLambdaPolicy
	Name: productVisitsLoadingLambdaRole

Unzip "DCTProductVisitsDataLake.zip" 

Edit index.js and update bucket name entry:

Bucket: 'product-visits-datalake'

Note: Change bucket name to YOUR bucket name

Then zip up contents (don't zip the whole folder) into "DCTProductVisitsDataLake.zip"

Create a function:
	Name: productVisitsDatalakeLoadingHandler
	Runtime: Node.js 12.x
	Role: productVisitsLoadingLambdaRole
	
Upload the code: DCTProductVisitsDataLake.zip

Go to DDB and open table

Choose Export and stream and create a trigger

Select function:
    Name: productVisitsDatalakeLoadingHandler

Go to AWS CLI and send messages:
    AWS CLI Command: `aws sqs send-message --queue-url *QUEUE URL* --message-body file://message-body-1.json`
    Modify: Queue name and file name
    File location: Code/build-a-serverless-app/part-2

## PART 3 - S3 Static Website - API Gateway REST API - Lambda ##

Create IAM Policy:
	JSON: Copy from lambda-policy.json
	Updates: change account number
	Name: productVisitsSendMessageLambdaPolicy

Account Number: *ACCOUNT NUMBER*
	
Create an IAM role:
	Use case: Lambda
	Policy: productVisitsSendMessageLambdaPolicy
	Name: productVisitsSendMessageLambdaRole
	
	
Unzip "DCTProductVisitForm.zip"

Edit index.js for backend and update queue name:

QueueUrl: "*QUEUE URL*"

Note: change above URL to YOUR queue URL

Then zip the backend folder contents to backend.zip

Create a Lambda function:
	Name: productVisitsSendDataToQueue
	Runtime: Node.js 12.x
	Role: productVisitsSendMessageLambdaRole
	
Upload code: backend.zip

Go to Amazon API Gateway

Create a REST API and select New API:
	Name: productVisit
	Endpoint type: Regional
	
Create a resource:
	Resource name: productVisit
	Resource path: /productVisit
	Enable CORS
	
Create a method:
	Type: PUT
	Integration type: Lambda function
	Use Lambda Proxy Integration
	Function: productVisitsSendDataToQueue
	
Deploy API - Actions > Deploy API

Create a new stage called "dev"

Go to SDK Generation and generate using platform "JavaScript"

Copy contents of donwloaded file to frontent folder

Create a bucket:
	Name: product-visits-webform
    Updates: Add letters/numbers to bucket name to be unique
	Region: us-east-1
	Turn off block public access
    
	
Enable static website hosting:
	Index: index.html
	Policy: copy contents of frontend-bucket-policy.json (edit bucket name)
	
Edit CORS settings by adding contents of cors-config.json

Edit index.html with correct Region if required:

region: 'us-east-1' // set this to the region you are running in.

Use command line to change to folder containing the frontend directory

Upload contents with AWS CLI command (change bucket name)

`aws s3 sync ./frontend s3://product-visits-webform`

Copy the object URL for index.html

Use URL to access application and then submit data using the form
