# Learn Terraform - Provision an EKS Cluster

This repo is a companion repo to the [Provision an EKS Cluster learn guide](https://learn.hashicorp.com/terraform/kubernetes/provision-eks-cluster), containing
Terraform configuration files to provision an EKS cluster on AWS.

Custom additions:
- allocates the Elastic IP outside the VPC module declaration
- creates Transit Gateway resources
- creates an RDS Aurora cluster