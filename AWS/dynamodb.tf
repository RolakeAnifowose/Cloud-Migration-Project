resource "aws_dynamodb_table" "cloud-migration-nosql-database" {
    name = "cloud-migration-nosql-database"
    billing_mode = "PROVISIONED"
    read_capacity= "30"
    write_capacity= "30"
    attribute {
    name = "Id"
    type = "S"
    }
    hash_key = "Id"
}

# module "table_autoscaling" {
#  source = "snowplow-devops/dynamodb-autoscaling/aws" // add the autoscaling module
#  table_name = aws_dynamodb_table.nosql-table.name // apply autoscaling
# }
