###################################################################################################################
# CloudWatch Logs — ECS
###################################################################################################################

resource "aws_cloudwatch_log_group" "ecs_api" {
  name              = var.cloudwatch_log_group_name
  retention_in_days = 7
  tags              = merge(local.common_tags, { Name = var.cloudwatch_log_group_name })
}
