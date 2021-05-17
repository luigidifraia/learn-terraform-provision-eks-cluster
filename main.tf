provider "aws" {
  region = var.region
}

locals {
  vpc_name         = "education-vpc"
  eks_cluster_name = "education-eks-${random_string.suffix.result}"
  rds_name         = "education-rds-aurora"
  bucket_name      = "education-bucket-${lower(random_string.suffix.result)}"

  database_name    = "education"

  k8s_namespace    = "default"
  role_name        = "educator"
  policy_name      = "education"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}
