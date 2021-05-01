provider "aws" {
  region = "eu-west-2"
}

locals {
  vpc_name         = "education-vpc"
  eks_cluster_name = "education-eks-${random_string.suffix.result}"
  rds_name         = "education-rds-aurora"

  database_name    = "education"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}
