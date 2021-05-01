module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "15.1.0"

  cluster_name    = local.eks_cluster_name
  cluster_version = "1.19"
  subnets         = module.vpc.private_subnets

  tags = {
    Environment = "training"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  node_groups = {
    node-group-1 = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_types = [ "t2.small" ]
      capacity_type  = "SPOT"
      k8s_labels = {
        Environment = "training"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
      }
      additional_tags = {
        ExtraTag = "example"
      }
    }
    node-group-2 = {
      desired_capacity = 1
      max_capacity     = 1
      min_capacity     = 1

      instance_types = [ "t2.medium" ]
      capacity_type  = "SPOT"
      k8s_labels = {
        Environment = "training"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
      }
      additional_tags = {
        ExtraTag = "example"
      }
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
