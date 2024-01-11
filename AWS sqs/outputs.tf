//
// Module: sempra-sqs
//
// Outputs
output "arn" {
  description = "Amazon Resource Name of the queue created in the SQS"
  value       = aws_sqs_queue.terraform_queue.arn
}

output "id" {
  description = "ID of the queue created in the SQS"
  value       = aws_sqs_queue.terraform_queue.id
}

output "sqs_default_alarm_arn" {
  description = "The unique ID of the default CloudWatch alarm for SQS."
  value = one(aws_cloudwatch_metric_alarm.sqs_default_alarm[*].arn)
}
