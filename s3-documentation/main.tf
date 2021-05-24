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
  source                    = "git::git@github.com:CarlsbergGBS/carlsberg-infra-source.git//modules/tf_aws_s3?ref=v7.2"

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
  
  is_cloudfront             = var.is_cloudfront
  user_actions              = var.user_actions
}

######  
data "aws_iam_policy_document" "iam_bucket_policy" {
  statement {
    sid       = "1"
    actions   = var.user_actions 
    resources = ["${module.s3-bucket.this_aws_s3_bucket_arn}/*", "${module.s3-bucket.this_aws_s3_bucket_arn}"]
  }
}

resource "aws_iam_policy" "iam_policy" {
  name   = "${var.environment}-${var.bucket_name}_iam_user_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.iam_bucket_policy.json
}

resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = module.s3-bucket.this_iam_user_name
  policy_arn = aws_iam_policy.iam_policy.arn
}
######

output "access_key" {
  value = module.s3-bucket.this_iam_access_key_id
}

output "secret_key" {
  value = module.s3-bucket.this_iam_access_key_secret
}