//
// Module: sempra-sqs
//
locals {
  service_code       = "sqs"
  temp_standard_name = join("-", [var.company_code, var.application_code, var.environment_code, var.region_code, local.service_code, var.application_name])
  standard_name      = var.fifo_queue == true ? "${local.temp_standard_name}.fifo" : local.temp_standard_name
  redrive_policy = jsonencode({
    deadLetterTargetArn = var.dead_letter_target_arn
    maxReceiveCount     = var.dlq_max_receive_count
  })
  kms_master_key_id = var.kms_master_key_id == "" ? "alias/aws/sqs" : var.kms_master_key_id
}

resource "aws_sqs_queue" "terraform_queue" {
  name                              = local.standard_name
  visibility_timeout_seconds        = var.visibility_timeout_seconds
  message_retention_seconds         = var.message_retention_seconds
  max_message_size                  = var.max_message_size
  delay_seconds                     = var.delay_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  redrive_policy                    = var.dead_letter_target_arn == "" ? "" : local.redrive_policy
  fifo_queue                        = var.fifo_queue
  content_based_deduplication       = var.content_based_deduplication
  kms_master_key_id                 = local.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds

  tags = merge(var.tags, var.additional_tags)
}

resource "aws_cloudwatch_metric_alarm" "sqs_default_alarm" {
  count = var.enable_monitoring ? 1 : 0
  alarm_name = "${local.standard_name}-SQS-Alarm"
  alarm_description   = "The alarm on number of messages to be processed."
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "300"
  statistic           = "Average"
  threshold           = "10"
  alarm_actions = [var.alarm_action]
  dimensions = {
    RuleName = aws_sqs_queue.terraform_queue.name
  }
}
