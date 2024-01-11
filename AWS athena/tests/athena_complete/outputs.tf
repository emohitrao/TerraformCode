//
// Module: terraform-aws-seu-athena
//
// Outputs

output "athena_workgroup_arn" {
  description = "Amazon Resource Name (ARN) of the workgroup"
  value       = module.athena.athena_workgroup_arn
}

output "athena_workgroup_id" {
  description = "The workgroup name"
  value       = module.athena.athena_workgroup_id
}

output "athena_database_id" {
  description = "The database name"
  value       = module.athena.athena_database_id
}

output "athena_named_query_name" {
  description = "The unique ID of the query."
  value       = module.athena.athena_named_query_name
}

output "athena_output_bucket_id" {
  description = "The name of the s3 output bucket for Athena."
  value       = module.s3-bucket.s3_bucket_id
}
output "glue_crawler_name" {
  description = "The name of the Glue Crawler."
  value       = module.glue-crawler.glue_crawler_name
}

output "glue_crawler_database_name" {
  description = "The name of the Glue Crawler database."
  value       = module.glue-crawler.glue_database_name
}

output "glue_crawler_name_keys" {
  description = "A list of only names from the glue_crawler_name map output"
  value       = keys(module.glue-crawler.glue_crawler_name)
}

output "glue_crawler_database_keys" {
  description = "A list of only names from the glue_grawler_name_keys map output"
  value       = keys(module.glue-crawler.glue_database_name)
}

output "crawler_role_id" {
  description = "Id of the crawler role"
  value       = module.athena_crawler_role.id
}

output "crawler_role_arn" {
  description = "Id of the crawler role"
  value       = module.athena_crawler_role.arn
}

output "s3_arn" {
  description = "arn of s3 bucket"
  value       = module.s3-bucket.s3_bucket_arn
}

output "s3_testdata_arn" {
  description = "arn of s3 test data folder"
  value       = "${module.s3-bucket.s3_bucket_arn}/test_data/"
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "athena_default_alarm_arn" {
  description = "The unique ID of the default cloudwatch alarm for athena."
  value = module.athena.athena_default_alarm_arn
}