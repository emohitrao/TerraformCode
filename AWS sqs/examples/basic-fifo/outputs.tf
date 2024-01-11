output "fifo-queue-arn" {
  description = "FIFO queue ARN"
  value       = module.basic-fifo-queue.arn
}

output "fifo-queue-id" {
  description = "FIFO queue ID"
  value       = module.basic-fifo-queue.id
}
