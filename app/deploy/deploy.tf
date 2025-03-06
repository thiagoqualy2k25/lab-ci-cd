data "aws_lb_target_group" "this" {
  name = "app-prod-tg"
}

data "aws_security_groups" "selected" {
  filter {
    name   = "tag:Name"
    values = ["app-prod-sg"]
  }
}

resource "aws_ecs_service" "this" {
  name            = "app-service"
  task_definition = "ci-cd-app"
  cluster         = var.cluster_name
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  availability_zone_rebalancing = "ENABLED"
  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = true
  }


  load_balancer {
    target_group_arn = aws_lb_target_group.foo.arn
    container_name   = "ci-cd-app"
    container_port   = 8000
  }

}

resource "aws_clowdwatch_log_group" "this" {
  name              = "/ecs/ci-cd-app"
  retention_in_days = 7
}
