## All commands should be run in ACCOUNT A

# Create user
aws iam create-user --user-name jack
# Create policy
aws iam create-policy --policy-name jack-s3 --policy-document file://jack-s3.json
# Attach policy
aws iam attach-user-policy --user-name jack --policy-arn "arn:aws:iam::327450895851:policy/jack-s3"
# List policies attached to Jack
aws iam list-attached-user-policies --user-name jack
# Create access keys and record access keys for later use
aws iam create-access-key --user-name jack
# Configure CLI with profile for Jack
aws configure --profile jack
# Shows the identity being used to execute commands (without any profile)
aws sts get-caller-identity
# Assume the role in Account B with external ID
aws sts assume-role --profile jack --role-arn "arn:aws:iam::235283820623:role/cross-account-s3-access" --role-session-name AWSCLI-Session --external-id XX9812DDF2V
# Configure access key ID, secret access key and session token as environment variables
export AWS_ACCESS_KEY_ID=RoleAccessKeyID
export AWS_SECRET_ACCESS_KEY=RoleSecretKey
export AWS_SESSION_TOKEN=RoleSessionToken
# Shows that we're now executing commands as the assumed role
aws sts get-caller-identity
# Run S3 commands to list bucket, make bucket, and delete bucket
aws s3 ls
aws s3 mb s3://test-create-bucket-account-b-e32e090f90d
aws s3 rb s3://test-create-bucket-account-b-e32e090f90d
# Remove environment variables
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
# Show that we are now executing commands as our Admin user again
aws sts get-caller-identity