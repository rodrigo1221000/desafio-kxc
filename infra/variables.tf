variable "aws_region" {
  description = "Região AWS."
  type        = string
}

variable "project_name" {
  description = "Nome do projeto (tags e nomes de recursos)."
  type        = string
}

variable "environment" {
  description = "Ambiente (ex.: dev, challenge)."
  type        = string
}

# --- Rede ---

variable "vpc_cidr_block" {
  description = "CIDR da VPC."
  type        = string
}

variable "subnet_cidr_blocks_public" {
  description = "Mapa AZ => CIDR das subnets públicas."
  type        = map(string)
}

variable "public_subnet_names" {
  description = "Mapa AZ => nome das subnets públicas."
  type        = map(string)
}

variable "subnet_cidr_blocks_private" {
  description = "Mapa AZ => CIDR das subnets privadas."
  type        = map(string)
}

variable "private_subnet_names" {
  description = "Mapa AZ => nome das subnets privadas."
  type        = map(string)
}

# --- RDS PostgreSQL ---

variable "db_identifier" {
  description = "Identificador da instância RDS."
  type        = string
}

variable "db_name" {
  description = "Nome do database PostgreSQL."
  type        = string
}

variable "db_username" {
  description = "Usuário master do PostgreSQL."
  type        = string
}

variable "db_password" {
  description = "Senha do PostgreSQL."
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Classe da instância RDS (ex.: db.t4g.micro)."
  type        = string
}

variable "db_engine_version" {
  description = "Versão do engine PostgreSQL."
  type        = string
}

# --- ECS / API ---

variable "ecs_cluster_name" {
  description = "Nome do cluster ECS."
  type        = string
}

variable "ecs_service_name" {
  description = "Nome do serviço ECS."
  type        = string
}

variable "ecs_task_family" {
  description = "Family da task definition."
  type        = string
}

variable "container_image" {
  description = "Imagem do container (URI ECR após o primeiro push)."
  type        = string
}

variable "api_port" {
  description = "Porta da API (API_PORT no container)."
  type        = number
}

variable "ecs_task_cpu" {
  description = "CPU da task Fargate."
  type        = string
}

variable "ecs_task_memory" {
  description = "Memória da task Fargate (MiB)."
  type        = string
}

variable "allowed_api_cidr" {
  description = "CIDR permitido no SG do ALB (porta 80)."
  type        = string
}

variable "ecr_repository_name" {
  description = "Nome do repositório ECR."
  type        = string
}

variable "cloudwatch_log_group_name" {
  description = "Nome do log group do ECS."
  type        = string
}
