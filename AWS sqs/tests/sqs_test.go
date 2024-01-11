/*
Sempra Terraform KMS test using Gruntwork Terratest

Requires Go to be installed on your local machine with the correct environment

*/

package test

import (
	"fmt"
	"testing"
	"strings"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/sqs"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/stretchr/testify/assert"
)

func GetQueueAttribute(t *testing.T, url string, attr string) string {
	sqsClient := sqs.New(session.New(), aws.NewConfig().WithRegion("us-west-2"))
	input := sqs.GetQueueAttributesInput{QueueUrl: aws.String(url), AttributeNames: []*string{aws.String("All")}}
	attributes, err := sqsClient.GetQueueAttributes(&input)
	if err != nil { 
		if strings.Contains(err.Error(), "NonExistentQueue") {
			return "NonExistentQueue"
		}
		t.Fatal(err)
	} 
	return *attributes.Attributes[attr]
}

func IsQueueCreated(t *testing.T, url string) bool {
	return GetQueueAttribute(t, url, "QueueArn") != "NonExistantQueue"
}

func TestTerraformBasicSqs(t *testing.T) {
	var aws_region string = "us-west-2"
	var application_name string = strings.ToLower(random.UniqueId())
	

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "./basic",

		Vars: map[string]interface{}{
			"application_name": application_name,
		},

		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": aws_region,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created.
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Confirm that the queue was created correctly by checking for the expected name in the ID (returns an https:// link)
	expected_queue_name := fmt.Sprintf("sdge-iac-sbx-wus2-sqs-%s", application_name)
	actual_queue_id := strings.Trim(terraform.OutputRequired(t, terraformOptions, "queue-id"), "\"")
	assert.True(t, strings.HasSuffix(actual_queue_id, expected_queue_name))

	// Confirm that the Queue was created and exists in AWS by looking for the actual_queue_id received above
	assert.True(t, IsQueueCreated(t, actual_queue_id))
}

func TestTerraformBasicFifoSqs(t *testing.T) {	
	var aws_region string = "us-west-2"
	var application_name string = strings.ToLower(random.UniqueId())
	

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "./basic-fifo",

		Vars: map[string]interface{}{
			"application_name": application_name,
		},

		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": aws_region,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created.
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Confirm that the queue was created correctly by checking for the expected name in the ID (returns an https:// link)
	expected_fifo_name := fmt.Sprintf("sdge-iac-sbx-wus2-sqs-%s.fifo", application_name)
	actual_fifo_id := strings.Trim(terraform.OutputRequired(t, terraformOptions, "fifo-queue-id"), "\"")
	assert.True(t, strings.HasSuffix(actual_fifo_id, expected_fifo_name))

	// Confirm that the Queue was created and exists in AWS by looking for the actual_queue_id received above
	assert.True(t, IsQueueCreated(t, actual_fifo_id))
}

func TestTerraformDlqSqs(t *testing.T) {
	application_name := strings.ToLower(random.UniqueId())
	awsRegion := "us-west-2"

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "./queue-with-dlq",

		Vars: map[string]interface{}{
			"application_name": application_name,
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created.
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Confirm that both queues were created correctly by checking for the expected name in the ID (returns an https:// link)
	expected_queue_name := fmt.Sprintf("sdge-iac-sbx-wus2-sqs-%s", application_name)
	expected_dlq_name := fmt.Sprintf("sdge-iac-sbx-wus2-sqs-%s-dlq", application_name)
	dlq_queue_id := strings.Trim(terraform.OutputRequired(t, terraformOptions, "dead-letter-queue-id"), "\"")
	msg_queue_id := strings.Trim(terraform.OutputRequired(t, terraformOptions, "example-queue-id"), "\"")
	
	assert.True(t, strings.HasSuffix(dlq_queue_id, expected_dlq_name))
	assert.True(t, strings.HasSuffix(msg_queue_id, expected_queue_name))

	// Confirm that the Queues were created and exist in AWS by looking for the queue_ids received above
	assert.True(t, IsQueueCreated(t, dlq_queue_id))
	assert.True(t, IsQueueCreated(t, msg_queue_id))

	redrive_attr := GetQueueAttribute(t, msg_queue_id, "RedrivePolicy")
	dlq_queue_arn := strings.Trim(terraform.OutputRequired(t, terraformOptions, "dead-letter-queue-arn"), "\"")
	assert.Contains(t, redrive_attr, dlq_queue_arn)	
}