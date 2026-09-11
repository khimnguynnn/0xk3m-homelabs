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
  version = "~> 6.0"

  name = "0xk3m-loki-logs"

  create_login_profile = false
  create_access_key    = true

  policies = {
    loki_s3 = aws_iam_policy.loki_s3.arn
  }
}

# Open WebUI S3 Storage
module "open_webui_s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "0xk3m-open-webui"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}

data "aws_iam_policy_document" "open_webui_s3" {
  statement {
    sid    = "OpenWebUIAccess"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]

    resources = [
      module.open_webui_s3_bucket.s3_bucket_arn,
      "${module.open_webui_s3_bucket.s3_bucket_arn}/*",
    ]
  }
}

resource "aws_iam_policy" "open_webui_s3" {
  name        = "0xk3m-open-webui-s3-access"
  description = "Access to the 0xk3m-open-webui bucket for Open WebUI"
  policy      = data.aws_iam_policy_document.open_webui_s3.json
}

module "open_webui_iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "~> 6.0"

  name = "0xk3m-open-webui"

  create_login_profile = false
  create_access_key    = true

  policies = {
    open_webui_s3 = aws_iam_policy.open_webui_s3.arn
  }
}
