# terraform-aws-seu-athena terraform module

Repo Link: https://dev.azure.com/SempraUtilities/SempraUtilities/_git/terraform-aws-seu-athena

# Introduction 
Terraform module for SEU Athena

# Terraform Versions
Terraform >= 1.4.6, < 2.0.0 are supported.

# Usage
Workgroup:
```hcl
locals {
  region           = "us-west-2"
  aws_region       = "us-west-2"
  company_code     = "sdge"
  application_code = "iac"
  environment_code = "sbx"
  region_code      = "wus2"
  namespace        = "iac-sbx-aws.sempra.com"
  owner            = "IAC team"
}

provider "aws" {
  region = local.region
}

module "athena_example" {
  source  = "app.terraform.io/SempraUtilities/seu-athena/aws"
  version = "x.x.x"

  company_code     = local.company_code
  application_code = local.application_code
  environment_code = local.environment_code
  region_code      = local.region_code
  application_use  = "athena-test"
  tags = {
    name                = "test"
    portfolio           = "IaC"
    unit                = "12345"
    tag-version         = "Holds the version of the tagging format."
    billing-guid        = "Internal order - from SAP"
    support-group       = "Distribution list in email format"
    environment         = "Environment deployed"
    cmdb-ci-id          = "CI ID as generated by ServiceNow CMDB"
    data-classification = "Data privacy classification"
  }

  create_workgroup                   = true
  workgroup_force_destroy            = true
  workgroup_description              = "Example IaC Athena Workgroup"
  enforce_workgroup_configuration    = true
  publish_cloudwatch_metrics_enabled = true
  output_location                    = "s3://my-s3-bucket/output/"
  workgroup_encryption_option        = "SSE_KMS"
  workgroup_kms_key_arn              = "my-athena-kms-key-arn"

  create_athena_database    = false
  create_athena_named_query = false
}
```

#Examples
* [workgroup](main.tf) - Workgroup Example


## Requirements

| Name | Version |
|------|---------|
| terraform | >= >= 0.13.0, <=1.0.3 |
| aws | >= 3.2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.2.0 | 

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tags | This allows Additional Tags but Not supported for the following modules: Sempra-S3 | `map(string)` | `{}` | no |
| application\_code | Application Code - 5 characters. Ex: 'iip' | `string` | n/a | yes |
| application\_use | Application use is the actual service, function, or subcomponent supporting the Application Code. Ex: 'imagestore' | `string` | n/a | yes |
| athena\_database\_bucket | Name of s3 bucket to save the results of the query execution. | `string` | `""` | no |
| athena\_db\_name | Name of the database to create. | `string` | `""` | no |
| company\_code | Company Code (sdge, corp, ent, scg) | `string` | n/a | yes |
| create\_athena\_database | Boolean to determine if Athena database is created. | `bool` | n/a | yes |
| create\_athena\_named\_query | Boolean to determine if Athena named query is created. | `bool` | n/a | yes |
| create\_workgroup | Boolean to determine if workgroup is created. | `bool` | n/a | yes |
| db\_encryption\_option | The type of key; one of SSE\_S3, SSE\_KMS, CSE\_KMS used to decrypt the data in S3. | `string` | `""` | no |
| db\_force\_destroy | A boolean that indicates all tables should be deleted from the database so that the database can be destroyed without error. The tables are not recoverable. | `bool` | `null` | no |
| db\_kms\_key\_arn | The KMS key ARN or ID; required for key types SSE\_KMS and CSE\_KMS. | `string` | `""` | no |
| enforce\_workgroup\_configuration | Boolean whether the settings for the workgroup override client-side settings. | `bool` | `null` | no |
| environment\_code | Environment Code ( dev, prd, sbx, tst, qa) | `string` | n/a | yes |
| named\_query\_database | The database to which the query belongs. | `string` | `""` | no |
| named\_query\_description | A brief explanation of the query. Maximum length of 1024. | `string` | `""` | no |
| named\_query\_name | The plain language name for the query. Maximum length of 128. | `string` | `""` | no |
| named\_query\_query | The text of the query itself. In other words, all query statements. Maximum length of 262144. | `string` | `""` | no |
| named\_query\_workgroup | The workgroup to which the query belongs. | `string` | `""` | no |
| output\_location | The location in Amazon S3 where your query results are stored, such as s3://path/to/query/bucket/. | `string` | `""` | no |
| publish\_cloudwatch\_metrics\_enabled | Boolean whether Amazon CloudWatch metrics are enabled for the workgroup. | `bool` | `null` | no |
| region\_code | AWS region code defined by Sempra ( wus2, wus1, eus1, eus2 ) | `string` | n/a | yes |
| tags | A Object of Tags used for tagging | <pre>object({<br>    name                = string,<br>    tag-version         = string,<br>    billing-guid        = string,<br>    unit                = string,<br>    portfolio           = string,<br>    support-group       = string,<br>    environment         = string,<br>    cmdb-ci-id          = string,<br>    data-classification = string,<br>  })</pre> | n/a | yes |
| workgroup\_description | Description of the workgroup. | `string` | `""` | no |
| workgroup\_encryption\_option | Indicates whether Amazon S3 server-side encryption with Amazon S3-managed keys (SSE\_S3), server-side encryption with KMS-managed keys (SSE\_KMS), or client-side encryption with KMS-managed keys (CSE\_KMS) is used. | `string` | `""` | no |
| workgroup\_force\_destroy | The option to delete the workgroup and its contents even if the workgroup contains any named queries. | `bool` | `null` | no |
| workgroup\_kms\_key\_arn | This is the KMS key Amazon Resource Name (ARN). | `string` | `""` | no |



## Outputs

| Name | Description |
|------|-------------|
| athena\_database\_id | The database name |
| athena\_named\_query\_name | The unique ID of the query. |
| athena\_workgroup\_arn | Amazon Resource Name (ARN) of the workgroup |
| athena\_workgroup\_id | The workgroup name |
