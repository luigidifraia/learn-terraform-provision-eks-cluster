output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

output "kubectl_config" {
  description = "kubectl config as generated by the module."
  value       = module.eks.kubeconfig
}

output "config_map_aws_auth" {
  description = "A kubernetes configuration to authenticate to this EKS cluster."
  value       = module.eks.config_map_aws_auth
}

output "region" {
  description = "AWS region."
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name."
  value       = local.eks_cluster_name
}

output "db_endpoint" {
  description = "DB cluster endpoint."
  value       = module.db.rds_cluster_endpoint
}

output "db_name" {
  description = "Name of the automatically provisioned database on cluster creation."
  value       = local.database_name
}

output "db_username" {
  description = "Master DB username."
  value       = module.db.rds_cluster_master_username
  sensitive   = true
}

output "db_password" {
  description = "Master DB password."
  value       = module.db.rds_cluster_master_password
  sensitive   = true
}