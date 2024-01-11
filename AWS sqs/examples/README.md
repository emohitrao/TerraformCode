# Introduction
This is an example Sempra specific Terraform AWS module for creating queues using SQS. By default this module will create a basic queue.

## Terraform Versions
Terraform 0.13 to < 2.0.0 is supported.

## Basic Usage
```hcl
module "basic-queue" {
  source           = "app.terraform.io/SempraUtilities/seu-sqs/aws"
  version          = "x.x.x"
  aws_region       = "us-west-2"
  company_code     = "sdge"
  application_code = "iac"
  environment_code = "sbx"
  region_code      = "wus2"
  application_name = "my_test_app"

  tags = {
    name                = "Resource name"
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
```

## Basic FIFO Usage
```hcl
module "basic-fifo-queue" {
  source           = "app.terraform.io/SempraUtilities/seu-sqs/aws"
  version          = "x.x.x"
  aws_region       = "us-west-2"
  company_code     = "sdge"
  application_code = "iac"
  environment_code = "sbx"
  region_code      = "wus2"
  application_name = "my_test_app"
  fifo_queue       = true

  tags = {
    name                = "Resource name"
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
```

## Queue with a Dead Letter Queue Usage
```hcl
module "dead-letter-queue" {
  source           = "app.terraform.io/SempraUtilities/seu-sqs/aws"
  version          = "x.x.x"
  aws_region       = "us-west-2"
  company_code     = "sdge"
  application_code = "iac"
  environment_code = "sbx"
  region_code      = "wus2"
  application_name = "my_test_app-dlq"

  tags = {
    name                = "Resource name"
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
  application_name       = "my_test_app"

  tags = {
    name                = "Resource name"
    environment         = "sbx"
    tag-version         = "1"
    billing-guid        = "21342414"
    unit                = "SDGE"
    portfolio           = "IAC"
    support_group       = "agile-iac@sdge.com"
    cmdb-ci-id          = "1234567"
    data-classification = "sensitive"
  }
}
```

## Examples
* [Basic Example](basic/main.tf) - Simple queue without FIFO setting
* [FIFO Example](basic-fifo/main.tf) - Simple queue with FIFO setting
* [DLQ Example](queue-with-dlq/main.tf) - Simple queue without FIFO, leveraging another queue as a DLQ

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.4.6, < 2.0.0 |
| aws | >= 3.2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 3.2.0, < 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tags | Additional/custom tags | `map(string)` | `{}` | no |
| application\_code | Application Code - 5 characters | `string` | n/a | yes |
| application\_name | Application Name | `string` | n/a | yes |
| aws\_region | AWS Region | `string` | n/a | yes |
| company\_code | Company Code (sdge, corp, ent, scg) | `string` | n/a | yes |
| content\_based\_deduplication | SQS - Enable content-based deduplication for FIFO queues? | `bool` | `false` | no |
| dead\_letter\_target\_arn | SQS - ARN for dead letter queue | `string` | `""` | no |
| delay\_seconds | SQS - Time in seconds that the delivery of all messages in the queue will be delayed | `number` | `0` | no |
| dlq\_max\_receive\_count | SQS max receive count before sending message to DLQ | `number` | `5` | no |
| environment\_code | Environment Code ( dev, prd, sbx, tst, qa) | `string` | n/a | yes |
| fifo\_queue | SQS - Is this queue First in First Out? | `bool` | `false` | no |
| kms\_data\_key\_reuse\_period\_seconds | SQS - Length of time in seconds for which an Amazon SQS can reuse a data key to encrupt/decrypt messages | `number` | `300` | no |
| kms\_master\_key\_id | SQS - ID of Customer Managed Key for Amazon SQS | `string` | `""` | no |
| max\_message\_size | SQS - Number of bytes a message con contain before the queue rejects it | `number` | `262144` | no |
| message\_retention\_seconds | SQS queue message retention in seconds | `number` | `345600` | no |
| receive\_wait\_time\_seconds | SQS - Time in seconds for which a ReceiveMessage call will wait for a message to arrive before returning | `number` | `0` | no |
| region\_code | AWS region code defined by Sempra ( wus2, wus1, eus1, eus2 ) | `string` | n/a | yes |
| tags | Tags for queue | <pre>object({<br>    tag-version = string,<br>    billing-guid = string,<br>    unit = string,<br>    portfolio = string,<br>    support-group = string,<br>    environment = string,<br>    cmdb-ci-id = string,<br>    data-classification = string,<br>    description = string,<br>    created_by = string,<br>  })</pre> | n/a | yes |
| visibility\_timeout\_seconds | SQS queue visibility timeout in seconds | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | Amazon Resource Name of the queue created in the SQS |
| id | ID of the queue created in the SQS |

## Testing
Testing was completed for all three scenarios above using TerraTest in the [tests folder](../tests/). These tests pass a randomly generated app name in Golang

## Authors
* [Robert Skelton](rskelton@sdge.com)