//
// Module: sempra-sqs
//
//  Variables
//
//  Required
variable "aws_region" {
  description = "AWS Region"
  type        = string
}
// Naming components
variable "company_code" {
  description = "Company Code (sdge, corp, ent, scg)"
  type        = string
}

variable "application_code" {
  description = "Application Code - 5 characters"
  type        = string
}

variable "application_name" {
  description = "Application Name"
  type        = string
}

variable "environment_code" {
  description = "Environment Code ( dev, prd, sbx, tst, qa)"
  type        = string
}

variable "region_code" {
  description = "AWS region code defined by Sempra ( wus2, wus1, eus1, eus2 )"
  type        = string
}

variable "tags" {
  description = "Tags for queue"
  type = object({
    name                = string,
    tag-version         = string,
    billing-guid        = string,
    unit                = string,
    portfolio           = string,
    support-group       = string,
    environment         = string,
    cmdb-ci-id          = string,
    data-classification = string,
  })
}

//  Optional
variable "dead_letter_target_arn" {
  description = "SQS - ARN for dead letter queue"
  type        = string
  default     = ""
}

variable "dlq_max_receive_count" {
  description = "SQS max receive count before sending message to DLQ"
  type        = number
  default     = 5
}

variable "visibility_timeout_seconds" {
  description = "SQS queue visibility timeout in seconds"
  type        = number
  default     = 30
}

variable "message_retention_seconds" {
  description = "SQS queue message retention in seconds"
  type        = number
  default     = 345600
}

variable "max_message_size" {
  description = "SQS - Number of bytes a message con contain before the queue rejects it"
  type        = number
  default     = 262144
}

variable "delay_seconds" {
  description = "SQS - Time in seconds that the delivery of all messages in the queue will be delayed"
  type        = number
  default     = 0
}

variable "receive_wait_time_seconds" {
  description = "SQS - Time in seconds for which a ReceiveMessage call will wait for a message to arrive before returning"
  type        = number
  default     = 0
}

variable "fifo_queue" {
  description = "SQS - Is this queue First in First Out?"
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "SQS - Enable content-based deduplication for FIFO queues?"
  type        = bool
  default     = false
}

variable "kms_master_key_id" {
  description = "SQS - ID of Customer Managed Key for Amazon SQS"
  type        = string
  default     = ""
}

variable "kms_data_key_reuse_period_seconds" {
  description = "SQS - Length of time in seconds for which an Amazon SQS can reuse a data key to encrupt/decrypt messages"
  type        = number
  default     = 300
}

variable "additional_tags" {
  description = "Additional/custom tags"
  type        = map(string)
  default     = {}
}

variable "enable_monitoring" {
  type = bool
  default = false
  description = "This  variable  when set to true enables monitoring for eventbridge."
}

variable "alarm_action" {
  type = string
  default = ""
  description = "This is the email sns subscription to get alerts."
}
