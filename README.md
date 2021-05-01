# Learn Terraform - Provision an EKS Cluster

This repo is a fork of the companion repo to the [Provision an EKS Cluster learn guide](https://learn.hashicorp.com/terraform/kubernetes/provision-eks-cluster), containing
Terraform configuration files to provision an EKS cluster on AWS.

## Customizations

The below changes were made, compared to the original repo:

- allocates the Elastic IP outside the VPC module declaration
- creates managed Node Groups instead of Worker Nodes
- creates a VPC Endpoint to privately connect to S3
- creates Transit Gateway resources
- creates an RDS Aurora cluster accessible from EKS workers
- creates an S3 bucket accessible from EKS workers

## RDS connection testing

```bash
export DATABASE_CLUSTER_ENDPOINT=$(terraform output --raw db_cluster_endpoint)
export DATABASE_CLUSTER_PORT=$(terraform output --raw db_cluster_port)
export DATABASE_USER=$(terraform output --raw db_username)
export DATABASE_PASSWORD=$(terraform output --raw db_password)
export DATABASE_NAME=$(terraform output --raw db_name)

kubectl run postgresql-client --rm --tty -i --restart='Never' \
  --image tmaier/postgresql-client \
  --env=PGPASSWORD="${DATABASE_PASSWORD}" \
  -- -h ${DATABASE_CLUSTER_ENDPOINT} -U ${DATABASE_USER} ${DATABASE_NAME}
```

## S3 access testing

```bash
export BUCKET_ID=$(terraform output --raw s3_bucket_id)

kubectl run awscli --rm --tty -i --restart='Never' \
  --image luigidifraia/awscli:v1.0.4 \
  -- s3 ls s3://${BUCKET_ID}
```
