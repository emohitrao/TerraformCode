//
// Module: terraform-aws-seu-athena
//

locals {
  service_code  = "athena"
  standard_name = join("-", [var.company_code, var.application_code, var.environment_code, var.region_code, local.service_code, var.application_use])
  tags          = merge(var.tags, var.additional_tags)
}

resource "aws_athena_workgroup" "athena_workgroup" {
  count       = var.create_workgroup ? 1 : 0
  name        = local.standard_name
  description = var.workgroup_description
  configuration {
    enforce_workgroup_configuration    = var.enforce_workgroup_configuration
    publish_cloudwatch_metrics_enabled = var.publish_cloudwatch_metrics_enabled
    result_configuration {
      output_location = var.output_location
      encryption_configuration {
        encryption_option = var.workgroup_encryption_option
        kms_key_arn       = var.workgroup_kms_key_arn
      }
    }
    requester_pays_enabled = var.requester_pays_enabled
  }
  force_destroy = var.workgroup_force_destroy
  tags          = local.tags
}

resource "aws_athena_database" "athena_db" {
  count  = var.create_athena_database ? 1 : 0
  name   = var.athena_db_name
  bucket = var.athena_database_bucket
  encryption_configuration {
    encryption_option = var.db_encryption_option
    kms_key           = var.db_kms_key_arn
  }
  force_destroy = var.db_force_destroy
}

resource "aws_athena_named_query" "athena_query" {
  count       = var.create_athena_named_query ? 1 : 0
  name        = var.named_query_name
  description = var.named_query_description
  workgroup   = var.named_query_workgroup
  database    = var.named_query_database
  query       = var.named_query_query
}

resource "aws_cloudwatch_metric_alarm" "athena_query_default_alarm" {
  count = var.enable_monitoring ? 1 : 0
  alarm_name = "${local.standard_name}-athena-query-execution-time"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 1
  metric_name = "EngineExecutionTime"
  namespace = "AWS/Athena"
  period = 300
  statistic = "Average"
  threshold = 300000
  alarm_description = "Alarm for Athena query execution time exceeding 5 minutes"
  alarm_actions = [var.alarm_action]
  dimensions = {
    QueryExecutionId = "all"
  }
}

resource "aws_cloudwatch_metric_alarm" "athena_query_dynamic_alarm" {
  count = length(var.athena_alarm)
  alarm_name = "${local.standard_name}-${var.athena_alarm[count.index].alarm_name}"
  tags = local.tags
  alarm_description = var.athena_alarm[count.index].alarm_description
  comparison_operator = var.athena_alarm[count.index].comparison_operator
  evaluation_periods = var.athena_alarm[count.index].evaluation_periods
  metric_name = var.athena_alarm[count.index].metric_name
  namespace = var.athena_alarm[count.index].namespace
  period = var.athena_alarm[count.index].period
  statistic = var.athena_alarm[count.index].statistic
  threshold = var.athena_alarm[count.index].threshold
  alarm_actions = [var.athena_alarm[count.index].alarm_action]
  dimensions = {
    QueryExecutionId = "all"
  }
}
