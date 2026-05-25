aws_region   = "us-east-1"
project_name = "kxc-challenge-api"
environment  = "challenge"

# Rede
vpc_cidr_block = "10.0.0.0/16"

subnet_cidr_blocks_public = {
  "us-east-1a" = "10.0.1.0/24"
  "us-east-1b" = "10.0.2.0/24"
}
public_subnet_names = {
  "us-east-1a" = "kxc-public-1a"
  "us-east-1b" = "kxc-public-1b"
}

subnet_cidr_blocks_private = {
  "us-east-1a" = "10.0.11.0/24"
  "us-east-1b" = "10.0.12.0/24"
}
private_subnet_names = {
  "us-east-1a" = "kxc-private-1a"
  "us-east-1b" = "kxc-private-1b"
}

# RDS PostgreSQL 
db_identifier     = "kxc-challenge-postgres"
db_name           = "challenge_db"
db_username       = "challenge_admin"
db_password       = "ChangeMeChallenge"
db_instance_class = "db.t4g.micro"
db_engine_version = "16.4"

# ECS Fargate  
ecs_cluster_name = "kxc-api-cluster"
ecs_service_name = "kxc-api-service"
ecs_task_family  = "kxc-simple-api"
container_image  = "kxc-simple-api:latest"
api_port         = 3000
ecs_task_cpu     = "256"
ecs_task_memory  = "512"
allowed_api_cidr = "0.0.0.0/0"

ecr_repository_name       = "kxc-simple-api"
cloudwatch_log_group_name = "/ecs/kxc-simple-api"
