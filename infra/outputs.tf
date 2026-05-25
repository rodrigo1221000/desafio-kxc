output "vpc_id" {
  description = "ID da VPC."
  value       = module.vpc_app.vpc_id
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas."
  value       = module.subnet_public.public_subnet_id
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas."
  value       = module.subnet_private.private_subnet_id
}

output "rds_endpoint" {
  description = "Host do RDS PostgreSQL."
  value       = module.rds_postgres.rds_endpoint
}

output "rds_port" {
  description = "Porta do RDS."
  value       = module.rds_postgres.rds_port
}

output "ecr_repository_url" {
  description = "URL do repositório ECR (use para docker push)."
  value       = aws_ecr_repository.api.repository_url
}

output "ecr_repository_name" {
  description = "Nome do repositório ECR (GitHub Actions / docker push)."
  value       = aws_ecr_repository.api.name
}

output "ecs_cluster_name" {
  description = "Nome do cluster ECS."
  value       = module.ecs_cluster.cluster_name
}

output "ecs_service_name" {
  description = "Nome do serviço ECS."
  value       = module.ecs_service.service_name
}

output "api_security_group_id" {
  description = "Security Group da API (ECS)."
  value       = module.security_group_api.security_group_id
}

output "alb_dns_name" {
  description = "DNS do ALB (use http://<dns>/ e http://<dns>/connect)."
  value       = module.alb.lb_dns_name
}

output "alb_target_group_arn" {
  description = "ARN do target group da API."
  value       = module.target_group_api.target_group_arn
}

 
