package tests

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/glue"
	"github.com/aws/aws-sdk-go/service/lakeformation"
	"github.com/gruntwork-io/terratest/modules/terraform"
	iebackoff "github.com/keikoproj/inverse-exp-backoff"
	"github.com/stretchr/testify/assert"
)

func getUserRoleArn(UserRoleArn string) string {
	if strings.Contains(UserRoleArn, "terratest") {
		UserRoleArn = "arn:aws:iam::743411803138:role/sdge-iac-sbx-wus2-terratest"
	} else {
		UserRoleArn = strings.Replace(UserRoleArn, "sts", "iam", 1)
		UserRoleArn = strings.Replace(UserRoleArn, "assumed-role", "role/aws-reserved/sso.amazonaws.com/us-west-2", 1)
		idx := strings.LastIndex(UserRoleArn, "/")
		UserRoleArn = UserRoleArn[:idx]
	}
	fmt.Println("Test is assuming the role: ", UserRoleArn)
	return UserRoleArn
}

func TestTerraformCompleteAthena(t *testing.T) {
	t.Parallel()

	awsRegion := "us-west-2"

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "athena_complete/",

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Gets crawler name
	glue_crawler_name := terraform.OutputList(t, terraformOptions, "glue_crawler_name_keys")
	crawler_name := glue_crawler_name[0]
	fmt.Println("crawler Name: ", crawler_name)

	// gets the crawler database name
	// This is the best way until we expose the output of glue_crawler_map
	// Currently the glue-crawler-map-database and the glue_crawler_database have the same ending "db-****"
	glue_crawler_db_name := terraform.OutputList(t, terraformOptions, "glue_crawler_database_keys")
	db := strings.Split(glue_crawler_db_name[0], "s3-")[1]
	fmt.Println("crawler database name: ", db)

	// Variables to set up lake formation env
	crawlerRoleArn := strings.Trim(terraform.Output(t, terraformOptions, "crawler_role_arn"), "\"")
	var permissions_db_table []string = []string{"ALL"}
	var locationpermissions []string = []string{"DATA_LOCATION_ACCESS"}
	s3TestDataArn := strings.Trim(terraform.Output(t, terraformOptions, "s3_testdata_arn"), "\"")
	currentRole := getUserRoleArn(strings.Trim(terraform.Output(t, terraformOptions, "caller_arn"), "\""))

	// Lake Formation client
	lake_formation := lakeformation.New(session.New(), aws.NewConfig().WithRegion(awsRegion))

	// registers test data folder s3 as a lake formation location
	_, err1 := lake_formation.RegisterResource(&lakeformation.RegisterResourceInput{
		ResourceArn:          aws.String(s3TestDataArn),
		UseServiceLinkedRole: aws.Bool(true),
	})
	if err1 != nil {
		fmt.Println("err1", err1)
	}

	_, permissionerr1 := lake_formation.GrantPermissions(&lakeformation.GrantPermissionsInput{
		Permissions: aws.StringSlice(locationpermissions),
		Principal: &lakeformation.DataLakePrincipal{
			DataLakePrincipalIdentifier: aws.String(crawlerRoleArn),
		},
		Resource: &lakeformation.Resource{
			DataLocation: &lakeformation.DataLocationResource{
				ResourceArn: aws.String(s3TestDataArn),
			},
		},
	})

	if permissionerr1 != nil {
		fmt.Println("permissionerr1", permissionerr1)
	}

	// Creates the glue client that will parse the test data bucket
	// will out put the results in the crawler-db
	glue_client := glue.New(session.New(), aws.NewConfig().WithRegion(awsRegion))
	glue_client.StartCrawler(&glue.StartCrawlerInput{Name: aws.String(crawler_name)})

	fmt.Println("Sleeping for up to 5 minutes, waiting for Glue Crawler to complete.")
	for ieb, err := iebackoff.NewIEBWithTimeout(2*time.Minute, 15*time.Second, 5*time.Minute, 0.5, time.Now()); err == nil; err = ieb.Next() {
		crawlerOutput, _ := glue_client.GetCrawler(&glue.GetCrawlerInput{Name: aws.String(crawler_name)})
		crawlerStatus := *crawlerOutput.Crawler.State == "READY"
		fmt.Println("Crawler State: ", *crawlerOutput.Crawler.State)
		if crawlerStatus == true {
			break
		}
	}

	// give user permission to read from the table
	_, permsissionerr2 := lake_formation.GrantPermissions(&lakeformation.GrantPermissionsInput{
		Permissions:                aws.StringSlice(permissions_db_table),
		PermissionsWithGrantOption: aws.StringSlice(permissions_db_table),
		Principal: &lakeformation.DataLakePrincipal{
			DataLakePrincipalIdentifier: aws.String(currentRole),
		},
		Resource: &lakeformation.Resource{
			Table: &lakeformation.TableResource{
				DatabaseName:  aws.String(db),
				TableWildcard: &lakeformation.TableWildcard{},
			},
		},
	})

	if permsissionerr2 != nil {
		fmt.Println("permsissionerr2", permsissionerr2)
	}

	_, permsissionerr3 := lake_formation.GrantPermissions(&lakeformation.GrantPermissionsInput{
		Permissions:                aws.StringSlice(permissions_db_table),
		PermissionsWithGrantOption: aws.StringSlice(permissions_db_table),
		Principal: &lakeformation.DataLakePrincipal{
			DataLakePrincipalIdentifier: aws.String(currentRole),
		},
		Resource: &lakeformation.Resource{
			Database: &lakeformation.DatabaseResource{
				Name: aws.String(db),
			},
		},
	})

	if permsissionerr3 != nil {
		fmt.Println("permsissionerr3", permsissionerr3)
	}
	// get workgroup_name
	workgroup := terraform.Output(t, terraformOptions, "athena_workgroup_id")
	fmt.Println("workgroup: ", workgroup)

	// Clean up
	// Manually deleting resources that terraform does not manage
	_, err4 := glue_client.DeleteDatabase(&glue.DeleteDatabaseInput{Name: aws.String(db)})
	if err4 != nil {
		fmt.Println(err4)
	}

	_, err5 := lake_formation.DeregisterResource(&lakeformation.DeregisterResourceInput{
		ResourceArn: aws.String(s3TestDataArn),
	})
	if err5 != nil {
		fmt.Println("err5", err5)
	}

	_, permsissionerr4 := lake_formation.RevokePermissions(&lakeformation.RevokePermissionsInput{
		Permissions: aws.StringSlice(locationpermissions),
		Principal: &lakeformation.DataLakePrincipal{
			DataLakePrincipalIdentifier: aws.String(crawlerRoleArn),
		},
		Resource: &lakeformation.Resource{
			DataLocation: &lakeformation.DataLocationResource{
				ResourceArn: aws.String(s3TestDataArn),
			},
		},
	})

	if permsissionerr4 != nil {
		fmt.Println("permsissionerr4", permsissionerr4)
	}
}

func TestTerraformAthenaDB(t *testing.T) {
	// Simple test to check if resource got created properly
	awsRegion := "us-west-2"

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "athena_database/",

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// get output
	database := terraform.Output(t, terraformOptions, "athena_database_id")

	assert.Contains(t, database, "iac_test_athena_db")
}

func TestTerraformAthenaWorkGroup(t *testing.T) {
	// Simple test to check if resource got created properly
	awsRegion := "us-west-2"

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "athena_named_query/",

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// get output
	workgroup_name := terraform.Output(t, terraformOptions, "athena_workgroup_id")

	assert.Contains(t, workgroup_name, "sdge-iac-sbx-wus2-athena")
}
