###################################################################################################################
# RDS PostgreSQL
###################################################################################################################

module "db_parameter_postgres" {
  source               = "../modulos/Banco_de_dados/prod/parameter-group"
  parameter_group_name = "${var.project_name}-pg-postgres16"
  family               = "postgres16"
  tags                 = merge(local.common_tags, { Name = "${var.project_name}-pg-postgres16" })
}

module "subnet_group_rds" {
  source = "../modulos/Banco_de_dados/prod/db-subnet-group"
  name   = "${var.project_name}-rds-subnet-group"
  subnet_ids = [
    for name in values(var.private_subnet_names) :
    module.subnet_private.private_subnet_ids_by_name[name]
  ]
  tags = merge(local.common_tags, { Name = "${var.project_name}-rds-subnet-group" })
}

module "rds_postgres" {
  source = "../modulos/Banco_de_dados/prod/rds"

  identifier            = var.db_identifier
  db_name               = var.db_name
  instance_class        = var.db_instance_class
  engine                = "postgres"
  engine_version        = var.db_engine_version
  license_model         = null
  username              = var.db_username
  password              = var.db_password
  port                  = "5432"
  allocated_storage     = "20"
  max_allocated_storage = "20"
  storage_type          = "gp2"

  character_set_name        = null
  final_snapshot_identifier = "${var.db_identifier}-final"
  final_snapshot            = false
  storage_encrypted         = false
  publicly_accessible       = false
  apply_immediately         = true
  backup_retention_period   = "1"
  backup_window             = "04:00-06:00"
  cloudwatch_logs_exports   = ["postgresql", "upgrade"]
  multi_az                  = false

  db_subnet_group_name = module.subnet_group_rds.db_subnet_group_name
  security_groups_ids  = [module.security_group_rds.security_group_id]
  parameter_group_name = module.db_parameter_postgres.parameter_group_name
  option_group_name    = "default:postgres-16"

  copy_tags_to_snapshot                 = true
  performance_insights                  = false
  performance_insights_retention_period = "0"
  allow_major_version_upgrade           = false
  auto_minor_version_upgrade            = true
  monitoring_interval                   = "0"
  maintenance_window                    = "sun:06:00-sun:07:00"
  deletion_protection                   = false
  delete_automated_backups              = true
  monitoring_role_arn                   = ""
  iam_database_authentication           = false
  customer_owned_ip                     = false
  ca_cert_identifier                    = "rds-ca-rsa2048-g1"

  tags = merge(local.common_tags, { Name = var.db_identifier })
}
