output "lb_dns_name" {
  value = aws_lb.backend.dns_name
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.default.id
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}
