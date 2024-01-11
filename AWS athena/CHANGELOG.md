# Changelog

All notable changes to terraform-aws-seu-athena will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Release 9.1.0
* Added cloutnative monitoring via cloudwatch for aws athena

## Release 9.0.0
* **BREAKING**: Now uses the minimum Terraform version of 1.4.6. Please upgrade your Terraform workspace to version 1.4.6 or greater. This will not be compatible with any SEU modules below version 9.0.0.

## Release 5.0.0
Updating Module to support Terraform 1.0.3
Removed aws_iam_policy_attachment

## Release 5.0.1
Module was failing Checkov test CKV_AWS_7 (Ensure rotation for customer created CMKs is enabled) in all tests directories.
Added enable_key_rotation    = true to resource "aws_kms_key" in all tests directories from Guideline: https://docs.bridgecrew.io/docs/logging_8

## Release 5.0.2
Changing shared-it-iac-support branch from master to main for release pipeline to succeed

## Release 6.0.0
Changing the module outputs to be string or null instead of lists of 1 or 0 items

## Release 6.1.0
Updating Module to support Terraform versions < 2.0.0

## Release 6.1.1
Updating Module to Remove References to TFE

## Release 7.0.0
Loosening AWS provider requirements

## Release 7.0.1
Migrate to shared-it-iac-pipeline-templates for module releases

## Release 7.0.2
Update pipeline to scan code with Checkmarx One

## Release 7.1.0
Update to support requester pays queries

## Release 7.1.1
* Limit AWS max provider version to less than 5.0.0

## Release 7.1.2
Fix: now using `additional_tags` variable

## Release 8.0.0
* Now uses AWS provider version 5 only. This will not be backwards compatible with any SEU module versions lower than 8.0.0.