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

module "dead-letter-queue" {
  source           = "app.terraform.io/SempraUtilities/seu-sqs/aws"
  version          = "x.x.x"
  aws_region       = "us-west-2"
  company_code     = "sdge"
  application_code = "iac"
  environment_code = "sbx"
  region_code      = "wus2"
  application_name = "${local.application_name}-dlq"

  tags = {
    name                = "Example DLQ"
    environment         = "sbx"
    tag-version         = "1"
    billing-guid        = "21342414"
    unit                = "SDGE"
    portfolio           = "IAC"
    support-group       = "agile-iac@sdge.com"
    cmdb-ci-id          = "1234567"
    data-classification = "sensitive"
  }
}



module "example-queue" {
  source                 = "app.terraform.io/SempraUtilities/seu-sqs/aws"
  version                = "x.x.x"
  aws_region             = "us-west-2"
  dead_letter_target_arn = module.dead-letter-queue.arn
  dlq_max_receive_count  = 4
  company_code           = "sdge"
  application_code       = "iac"
  environment_code       = "sbx"
  region_code            = "wus2"
  application_name       = local.application_name

  tags = {
    name                = "Example queue with DLQ"
    environment         = "sbx"
    tag-version         = "1"
    billing-guid        = "21342414"
    unit                = "SDGE"
    portfolio           = "IAC"
    support-group       = "agile-iac@sdge.com"
    cmdb-ci-id          = "1234567"
    data-classification = "sensitive"
  }
}
