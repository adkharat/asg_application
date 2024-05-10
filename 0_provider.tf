# https://registry.terraform.io/providers/hashicorp/aws/latest

provider "aws" {
  region = var.aws_region
}


terraform {
  required_version = ">= 0.13"

  backend "s3" {
    bucket = "terraformstateaks"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "state-locking"
  }

}