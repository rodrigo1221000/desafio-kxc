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

output "deploy_notes" {
  description = "Passos após o primeiro apply."
  value       = <<-EOT
    CI/CD: push em main em simple-api-main/ dispara .github/workflows/api-deploy.yml
    Manual:
    1. aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com
    2. docker build -t ${aws_ecr_repository.api.repository_url}:latest ../simple-api-main
    3. docker push ${aws_ecr_repository.api.repository_url}:latest
    4. Atualize o serviço ECS (workflow api-deploy ou console)
    5. Teste GET / e GET /connect no IP público da task (ECS > task > ENI)
  EOT
}
