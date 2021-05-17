#############################
## OpenID Connect Provider ##
#############################
data "tls_certificate" "main" {
  url = module.eks.cluster_oidc_issuer_url
}

resource "aws_iam_openid_connect_provider" "main" {
  url = module.eks.cluster_oidc_issuer_url

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [
    data.tls_certificate.main.certificates.0.sha1_fingerprint
  ]
}

##################
## IAM Policies ##
##################
data "aws_iam_policy_document" "role_trust_relationship" {
  statement {
    sid = "AssumeRole"

    principals {
      type        = "Federated"
      identifiers = [ aws_iam_openid_connect_provider.main.arn ]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.main.url}:sub"
      values   = [ "system:serviceaccount:${local.k8s_namespace}:${local.role_name}" ]
    }
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid = "BucketActions"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      module.bucket.s3_bucket_arn,
    ]
  }
}

################
## IAM Policy ##
################
resource "aws_iam_policy" "main" {
  name        = local.policy_name
  path        = "/"
  description = "Allow AWS EKS PODs to list S3 bucket contents"

  policy      = data.aws_iam_policy_document.s3_policy.json
}

##############
## IAM Role ##
##############
resource "aws_iam_role" "main" {
  name                  = local.role_name
  path                  = "/"
  assume_role_policy    = data.aws_iam_policy_document.role_trust_relationship.json
  force_detach_policies = false
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.main.arn
}

#########################
## K8s Service Account ##
#########################
resource "kubernetes_service_account" "main" {
  metadata {
    name      = local.role_name
    namespace = local.k8s_namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.main.arn
    }
  }
  automount_service_account_token = true
}
