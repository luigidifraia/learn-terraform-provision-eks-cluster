module "db" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "5.0.0"

  name                    = local.rds_name
  engine                  = "aurora-postgresql"
  engine_version          = "12.4"
  instance_type           = "db.t3.medium"
  instance_type_replica   = "db.t3.medium"

  vpc_id                  = module.vpc.vpc_id
  db_subnet_group_name    = module.vpc.database_subnet_group_name

  allowed_cidr_blocks     = module.vpc.private_subnets_cidr_blocks
  allowed_security_groups = [ module.eks.worker_security_group_id ]

  database_name           = local.database_name
  create_random_password  = true

  apply_immediately       = true
  skip_final_snapshot     = true
}