###################################################################################################################
# ALB
###################################################################################################################

module "alb" {
  source = "../modulos/Aplicacao/prod/balancer/alb"

  lb_name                    = "${var.project_name}-alb"
  internal                   = false
  enable_deletion_protection = false
  security_group_ids         = [module.security_group_alb.security_group_id]
  subnet_ids                 = module.subnet_public.public_subnet_id
  access_logs_bucket         = ""
  access_logs_prefix         = ""
  access_logs_enabled        = false
  type                       = "application"
  tags                       = merge(local.common_tags, { Name = "${var.project_name}-alb" })
}

module "target_group_api" {
  source = "../modulos/Aplicacao/prod/balancer/target_group"

  tg_name                       = "${var.project_name}-api-tg"
  target_type                   = "ip"
  target_group_port             = var.api_port
  target_group_protocol         = "HTTP"
  target_group_protocol_version = "HTTP1"
  vpc_id                        = module.vpc_app.vpc_id
  health_check_protocol         = "HTTP"
  health_check_path             = "/"
  health_check_port             = "traffic-port"
  healthy_threshold             = 2
  unhealthy_threshold           = 3
  health_check_timeout          = 5
  health_check_interval         = 30
  health_check_matcher          = "200"
  tags                          = merge(local.common_tags, { Name = "${var.project_name}-api-tg" })
}

resource "aws_lb_listener" "api_http" {
  load_balancer_arn = module.alb.lb_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = module.target_group_api.target_group_arn
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-alb-http" })
}
