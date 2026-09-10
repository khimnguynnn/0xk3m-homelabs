module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "0xk3m-loki-logs"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}

data "aws_iam_policy_document" "loki_s3" {
  statement {
    sid    = "FullAccessExceptDeleteBucket"
    effect = "Allow"

    actions = ["s3:*"]

    resources = [
      module.s3_bucket.s3_bucket_arn,
      "${module.s3_bucket.s3_bucket_arn}/*",
    ]
  }

  statement {
    sid    = "DenyDeleteBucket"
    effect = "Deny"

    actions   = ["s3:DeleteBucket"]
    resources = [module.s3_bucket.s3_bucket_arn]
  }
}

resource "aws_iam_policy" "loki_s3" {
  name        = "0xk3m-loki-logs-s3-full-access"
  description = "Full access to the 0xk3m-loki-logs bucket except deleting the bucket"
  policy      = data.aws_iam_policy_document.loki_s3.json
}

module "iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "~> 5.60"

  name = "0xk3m-loki-logs"

  create_iam_user_login_profile = false
  create_iam_access_key         = true

  policy_arns = [aws_iam_policy.loki_s3.arn]
}
