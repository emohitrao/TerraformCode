output "queue-arn" {
  description = "The basic queue's ARN"
  value       = module.basic-queue.arn
}

output "queue-id" {
  description = "The basic queue's ID"
  value       = module.basic-queue.id
}
