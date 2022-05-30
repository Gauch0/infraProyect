terraform {
  backend "s3" {
      bucket = "matias-api-test"
      key = "matias-api-test/terraform.state"
      region = "us-east-1"
  }
}

data "terraform_remote_state" "endavavpc" {
    backend = "s3"
    config = {
        bucket = "matias-api-test"
        key = "vpc/terraform.state"
        region = "us-east-1"
    }
}