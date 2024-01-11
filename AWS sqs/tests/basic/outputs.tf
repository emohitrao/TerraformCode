output "queue-arn" {
  description = "The basic queue's ARN"
  value       = module.basic-queue.arn
}

output "queue-id" {
  description = "The basic queue's ID"
  value       = module.basic-queue.id
}

output "sqs_default_alarm_arn" {
  description = "The unique ID of the default CloudWatch alarm for SQS."
  value       = module.basic-queue.sqs_default_alarm_arn
}