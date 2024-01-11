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
output "athena_default_alarm_arn" {
  description = "The unique ID of the default cloudwatch alarm for athena."
  value = module.athena.athena_default_alarm_arn
}


output "athena__dynamic_alarm_arn" {
  description = "The unique ID of the dynamic cloudwatch alarm for athena."
  value = module.athena.athena_dynamic_alarm_arn
}