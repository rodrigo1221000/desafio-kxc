###################################################################################################################
# Security Groups — API (ECS) e RDS PostgreSQL
###################################################################################################################

module "security_group_api" {
  source      = "../modulos/Conectividade/prod/security-group"
  name        = "${var.project_name}-api-sg"
  description = "ECS Fargate - simple-api"
  vpc_id      = module.vpc_app.vpc_id
  ingress_rules = [
    {
      description = "API HTTP"
      from_port   = var.api_port
      to_port     = var.api_port
      protocol    = "tcp"
      cidr_blocks = [var.allowed_api_cidr]
    }
  ]
  egress_rules = [
    {
      description = "Saida geral"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = merge(local.common_tags, { Name = "${var.project_name}-api-sg" })
}

module "security_group_rds" {
  source      = "../modulos/Conectividade/prod/security-group"
  name        = "${var.project_name}-rds-sg"
  description = "RDS PostgreSQL - acesso apenas do ECS"
  vpc_id      = module.vpc_app.vpc_id
  ingress_rules = [
    {
      description     = "PostgreSQL do ECS"
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      security_groups = [module.security_group_api.security_group_id]
    }
  ]
  egress_rules = [
    {
      description = "Saida geral"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  tags = merge(local.common_tags, { Name = "${var.project_name}-rds-sg" })
}
