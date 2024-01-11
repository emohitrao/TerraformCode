//
// Module: terraform-aws-seu-athena
//
// Outputs
output "athena_workgroup_arn" {
  description = "Amazon Resource Name (ARN) of the workgroup."
  value       = one(aws_athena_workgroup.athena_workgroup.*.arn)
}

output "athena_workgroup_id" {
  description = "The workgroup name."
  value       = one(aws_athena_workgroup.athena_workgroup.*.id)
}

output "athena_database_id" {
  description = "The database name, although it is referred to as ID."
  value       = one(aws_athena_database.athena_db.*.id)
}

output "athena_named_query_name" {
  description = "The unique ID of the query."
  value       = one(aws_athena_named_query.athena_query.*.id)
}

output "athena_default_alarm_arn" {
  description = "The unique ID of the default cloudwatch alarm for athena."
  value = [for alarm in aws_cloudwatch_metric_alarm.athena_query_default_alarm : alarm.arn]
}


output "athena__dynamic_alarm_arn" {
  description = "The unique ID of the dynamic cloudwatch alarm for athena."
  value = [for alarm in aws_cloudwatch_metric_alarm.athena_query_dynamic_alarm : alarm.arn]
}