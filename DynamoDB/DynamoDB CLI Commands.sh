# Import data
aws dynamodb batch-write-item --request-items file://mystore.json

# Perform scan of ProductOrders table:
aws dynamodb scan --table-name mystore
