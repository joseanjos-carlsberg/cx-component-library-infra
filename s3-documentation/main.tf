terraform {
  backend "s3" {
    bucket                  = "carlsberg-tf-states"
    key                     = "infra/aws/carlsberg-dev-4834-5903-6065/acn-gbs-cxproject-dev-01/dev/cx-component-library/s3/state.tf"
    region                  = "eu-west-1"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "cx-tf-states"
  }
}

provider "aws" {
  region                    = "eu-west-1"
  shared_credentials_file   = "~/.aws/credentials"
  profile                   = "Carlsberg-Dev"
}


module "s3-bucket" {
  source                    = "git::git@github.com:CarlsbergGBS/carlsberg-infra-source.git//modules/tf_aws_s3?ref=v6.9"

  region                    = var.region
  bucket_name               = var.bucket_name
  actions                   = var.actions
  acl                       = var.acl
  block_public_acls         = var.block_public_acls
  block_public_policy       = var.block_public_policy
  ignore_public_acls        = var.ignore_public_acls
  restrict_public_buckets   = var.restrict_public_buckets
  environment               = var.environment
  tags                      = var.tags
  #cors_rule                 = var.cors_rule
  is_cloudfront             = var.is_cloudfront
}

output "access_key" {
  value = module.s3-bucket.this_iam_access_key_id
}

output "secret_key" {
  value = module.s3-bucket.this_iam_access_key_secret
}