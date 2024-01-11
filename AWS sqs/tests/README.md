# Terratest

Terratest is a Go library that makes it easier to write automated tests for your infrastructure code. It provides a variety of helper functions and patterns for common infrastructure testing tasks.


# How to run terratest

```
 cd test
 go test -v -timeout 30m
```

# Example output

```
$ go test -v
=== RUN   TestTerraformHelloWorldExample
Running command terraform with args [init]
Initializing provider plugins...
[...]
Terraform has been successfully initialized!
[...]
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
Outputs:
hello_world = "Hello, World!"
[...]
Running command terraform with args [destroy -force -input=false]
[...]
Destroy complete! Resources: 2 destroyed.
--- PASS: TestTerraformHelloWorldExample (149.36s)```