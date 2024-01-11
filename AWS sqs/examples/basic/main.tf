# This example generates a random 6 character string as the app name
# The random app name is only used if an application name was not specified
resource "random_string" "random" {
  length  = 6
  special = false
}

locals {
  # App name is random string from above only if an application_name value has not been provided
  application_name = var.application_name == "" ? random_string.random.result : var.application_name
}


module "basic-queue" {
  source           = "app.terraform.io/SempraUtilities/seu-sqs/aws"
  version          = "x.x.x"
  aws_region       = "us-west-2"
  company_code     = "sdge"
  application_code = "iac"
  environment_code = "sbx"
  region_code      = "wus2"
  application_name = local.application_name

  tags = {
    name                = "Captures the resource name details"
    tag-version         = "Holds the version of the tagging format"
    billing-guid        = "Internal order - from SAP source of truth"
    unit                = "Organizational unit ex: SDGE SoCalGas Ent Corp"
    portfolio           = "Portfolio associated with the application"
    support-group       = "Distribution list in email format"
    environment         = "Environment deployed to ex: DEV TST QA PRD"
    cmdb-ci-id          = "CI ID as generated by ServiceNow or CMDB. Format: ASM followed by a 7-digit zero padded value"
    data-classification = "Data privacy classification ex: public sensitive confidential"
  }
  enable_monitoring = true
  alarm_action = module.sns.email_subscription_arn[0]
}

module "sns" {
  source           = "app.terraform.io/SempraUtilities/seu-sqs/aws"
  version          = "x.x.x"
  application_use       = local.application_use
  company_code          = local.company_code
  application_code      = local.application_code
  environment_code      = local.environment_code
  region_code           = local.region_code
  tags                  = local.tags
  email_subscriber_list = ["mail@sa377abcrandom.com", "mail@sa3772abcrandom.com"]
  create_email_topic    = true
}