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

module "basic-fifo-queue" {
  source           = "../../"
  aws_region       = "us-west-2"
  company_code     = "sdge"
  application_code = "iac"
  environment_code = "sbx"
  region_code      = "wus2"
  application_name = local.application_name
  fifo_queue       = true

  tags = {
    name                = "Basic fifo example queue"
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
