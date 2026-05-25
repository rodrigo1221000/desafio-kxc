###################################################################################################################
# ECS Fargate
###################################################################################################################

module "ecs_cluster" {
  source                     = "../modulos/Aplicacao/prod/ecs/cluster"
  cluster_name               = var.ecs_cluster_name
  container_insights_enabled = false
  tags                       = merge(local.common_tags, { Name = var.ecs_cluster_name })
}

locals {
  container_definitions_api = [
    {
      name      = "simple-api"
      image     = var.container_image
      essential = true
      portMappings = [
        {
          containerPort = var.api_port
          hostPort      = var.api_port
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "API_PORT", value = tostring(var.api_port) },
        { name = "DB_HOST", value = module.rds_postgres.rds_endpoint },
        { name = "DB_PORT", value = tostring(module.rds_postgres.rds_port) },
        { name = "DB_USER", value = var.db_username },
        { name = "DB_PASSWORD", value = var.db_password },
        { name = "DB_DATABASE", value = var.db_name },
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_api.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ]
}

module "ecs_task_definition" {
  source                   = "../modulos/Aplicacao/prod/ecs/task-definition"
  family                   = var.ecs_task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = null
  container_definitions    = local.container_definitions_api
  volumes                  = []
  tags                     = merge(local.common_tags, { Name = var.ecs_task_family })
}

module "ecs_service" {
  source              = "../modulos/Aplicacao/prod/ecs/service"
  service_name        = var.ecs_service_name
  cluster_id          = module.ecs_cluster.cluster_id
  task_definition_arn = module.ecs_task_definition.task_definition_arn
  desired_count       = 1
  launch_type         = "FARGATE"
  subnet_ids          = module.subnet_public.public_subnet_id
  security_group_ids  = [module.security_group_api.security_group_id]
  assign_public_ip    = true
  load_balancer = {
    target_group_arn = module.target_group_api.target_group_arn
    container_name   = "simple-api"
    container_port   = var.api_port
  }
  service_registry                  = null
  deployment_maximum_percent        = 200
  deployment_minimum_percent        = 100
  health_check_grace_period_seconds = 60
  enable_execute_command            = false
  tags                              = merge(local.common_tags, { Name = var.ecs_service_name })

  depends_on = [aws_lb_listener.api_http]
}
