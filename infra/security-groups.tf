###################################################################################################################
# Security Groups
###################################################################################################################

module "security_group_alb" {
  source      = "../modulos/Conectividade/prod/security-group"
  name        = "${var.project_name}-alb-sg"
  description = "ALB - entrada HTTP publica"
  vpc_id      = module.vpc_app.vpc_id
  ingress_rules = [
    {
      description = "HTTP do ALB"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = [var.allowed_api_cidr]
    }
  ]
  egress_rules = [
    {
      description = "Saida para tasks ECS"
      from_port   = var.api_port
      to_port     = var.api_port
      protocol    = "tcp"
      cidr_blocks = [var.vpc_cidr_block]
    }
  ]
  tags = merge(local.common_tags, { Name = "${var.project_name}-alb-sg" })
}

module "security_group_api" {
  source      = "../modulos/Conectividade/prod/security-group"
  name        = "${var.project_name}-api-sg"
  description = "ECS Fargate - simple-api (somente via ALB)"
  vpc_id      = module.vpc_app.vpc_id
  ingress_rules = [
    {
      description     = "API HTTP do ALB"
      from_port       = var.api_port
      to_port         = var.api_port
      protocol        = "tcp"
      security_groups = [module.security_group_alb.security_group_id]
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
