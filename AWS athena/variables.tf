//
// Module: terraform-aws-seu-athena
//
//  Variables
//
//  Required

// Naming components

variable "company_code" {
  description = "Company Code (sdge, corp, ent, scg)"
  type        = string
}

variable "application_code" {
  description = "Application Code - 5 characters. Ex: 'iip' "
  type        = string
}

variable "application_use" {
  description = "Application use is the actual service, function, or subcomponent supporting the Application Code. Ex: 'imagestore' "
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
// Tags
variable "tags" {
  description = "A Object of Tags used for tagging"
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

variable "additional_tags" {
  description = "This allows Additional Tags but Not supported for the following modules: Sempra-S3"
  type        = map(string)
  default     = {}
}


variable "create_workgroup" {
  description = "Boolean to determine if workgroup is created."
  type        = bool
}
variable "enforce_workgroup_configuration" {
  description = "Boolean whether the settings for the workgroup override client-side settings."
  type        = bool
  default     = null
}
variable "publish_cloudwatch_metrics_enabled" {
  description = "Boolean whether Amazon CloudWatch metrics are enabled for the workgroup."
  type        = bool
  default     = null
}
variable "output_location" {
  description = "The location in Amazon S3 where your query results are stored, such as s3://path/to/query/bucket/."
  type        = string
  default     = ""
}
variable "workgroup_encryption_option" {
  description = "Indicates whether Amazon S3 server-side encryption with Amazon S3-managed keys (SSE_S3), server-side encryption with KMS-managed keys (SSE_KMS), or client-side encryption with KMS-managed keys (CSE_KMS) is used."
  type        = string
  default     = ""
}
variable "workgroup_kms_key_arn" {
  description = "This is the KMS key Amazon Resource Name (ARN)."
  type        = string
  default     = ""
}
variable "workgroup_description" {
  description = "Description of the workgroup."
  type        = string
  default     = ""
}
variable "workgroup_force_destroy" {
  description = "The option to delete the workgroup and its contents even if the workgroup contains any named queries."
  type        = bool
  default     = null
}



variable "create_athena_database" {
  description = "Boolean to determine if Athena database is created."
  type        = bool
}
variable "athena_database_bucket" {
  description = "Name of s3 bucket to save the results of the query execution."
  type        = string
  default     = ""
}
variable "db_encryption_option" {
  description = "The type of key; one of SSE_S3, SSE_KMS, CSE_KMS used to decrypt the data in S3."
  type        = string
  default     = ""
}
variable "db_kms_key_arn" {
  description = "The KMS key ARN or ID; required for key types SSE_KMS and CSE_KMS."
  type        = string
  default     = ""
}
variable "athena_db_name" {
  description = "Name of the database to create."
  type        = string
  default     = ""
}
variable "db_force_destroy" {
  description = "A boolean that indicates all tables should be deleted from the database so that the database can be destroyed without error. The tables are not recoverable."
  type        = bool
  default     = null
}

variable "create_athena_named_query" {
  description = "Boolean to determine if Athena named query is created."
  type        = bool
}
variable "named_query_name" {
  description = "The plain language name for the query. Maximum length of 128."
  type        = string
  default     = ""
}
variable "named_query_description" {
  description = "A brief explanation of the query. Maximum length of 1024."
  type        = string
  default     = ""
}
variable "named_query_workgroup" {
  description = "The workgroup to which the query belongs."
  type        = string
  default     = ""
}
variable "named_query_database" {
  description = "The database to which the query belongs."
  type        = string
  default     = ""
}
variable "named_query_query" {
  description = "The text of the query itself. In other words, all query statements. Maximum length of 262144."
  type        = string
  default     = ""
}
variable "requester_pays_enabled" {
  description = "Boolean whether to support queries on buckets that have requester pays setting on."
  type        = bool
  default     = false
}

variable "enable_monitoring" {
  type = bool
  default =  false
  description = "This variable when set to true enables monitoring for Athena. The monitoring resources may incur additional  costs."
}
variable "alarm_action" {
  type = string
  default = ""
  description = "This is the email sns subscription to get alerts."
}

variable "athena_alarm" {
  type = list(object({
    alarm_name = string
    comparison_operator = string
    evaluation_periods = string
    metric_name = string
    namespace = string
    period = number
    statistic = string
    threshold = number
    alarm_description = string
    alarm_action = string
  }))
  default = []
  description = "This is a list of alarms which can to be created for Athena"
}