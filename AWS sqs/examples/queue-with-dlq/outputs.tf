output "dead-letter-queue-arn" {
  description = "Dead letter queue ARN"
  value       = module.dead-letter-queue.arn
}

output "dead-letter-queue-id" {
  description = "Dead letter queue ID"
  value       = module.dead-letter-queue.id
}

output "example-queue-arn" {
  description = "Queue ARN - queue leveraging DLQ"
  value       = module.example-queue.arn
}

output "example-queue-id" {
  description = "Queue ID - queue leveraging DLQ"
  value       = module.example-queue.id
}
