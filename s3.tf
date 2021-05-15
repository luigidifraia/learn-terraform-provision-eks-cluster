data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "BucketActions"

    principals {
      type        = "AWS"
      identifiers = [
        module.eks.worker_iam_role_arn,
      ]
    }

    actions = [
      "s3:ListBucket",
      "s3:GetBucketAcl",
    ]

    resources = [
      module.bucket.s3_bucket_arn,
    ]
  }
  statement {
    sid = "ObjectActions"

    principals {
      type        = "AWS"
      identifiers = [ module.eks.worker_iam_role_arn ]
    }

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObjectAcl",
    ]

    resources = [
      "${module.bucket.s3_bucket_arn}/*",
    ]
  }
  statement {
    sid = "AllowSSLRequestsOnly"

    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = [ "*" ]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      module.bucket.s3_bucket_arn,
      "${module.bucket.s3_bucket_arn}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = [ "false" ]
    }
  }
}

module "bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.1.0"

  bucket        = local.bucket_name
  force_destroy = true

  attach_policy = true
  policy        = data.aws_iam_policy_document.bucket_policy.json

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "AES256"
      }
    }
  }

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
