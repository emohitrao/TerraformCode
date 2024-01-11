# Changelog

All notable changes to sempra-sqs will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).
## Release 9.1.0
* Cloud Native Monitoring Terraform Pattern for AWS SQS

## Release 9.0.0
* **BREAKING**: Now uses the minimum Terraform version of 1.4.6. Please upgrade your Terraform workspace to version 1.4.6 or greater. This will not be compatible with any SEU modules below version 9.0.0.

## Release 3.0.0
Updating Module to support Terraform 1.0.3

## Release 3.1.0
Updating Module to support Terraform versions < 2.0.0

## Release 3.1.1
Updating Module to Remove References to TFE

## Release 4.0.0
Loosening AWS provider requirements

## Release 4.0.1
Migrate to shared-it-iac-pipeline-templates for module releases

## Release 4.0.2
Use Checkmarx One from master branch

## Release 4.0.3
* Limit AWS max provider version to less than 5.0.0

## Release 4.0.4
Enabled server-side encryption

## Release 4.0.5 
Enabled server-side encryption with aws default kms key "alias/aws/sqs"

## Release 8.0.0
* Now uses AWS provider version 5 only. This will not be backwards compatible with any SEU module versions lower than 8.0.0.
