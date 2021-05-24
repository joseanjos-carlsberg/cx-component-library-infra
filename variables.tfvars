region                  = "eu-west-1"
bucket_name             = "cx-component-library-infra-documentation"
actions                 = ["s3:*"]
user_actions            = ["s3:*"]
acl                     = "private"
block_public_acls       = true
block_public_policy     = true
ignore_public_acls      = true
restrict_public_buckets = true
environment             = "dev"
tags                    = {
    #Environment = "dev"
    Objective   = "For documentation"
}

is_cloudfront            = false
