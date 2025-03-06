data "aws_lb_target_group" "this" {
  name = "app-prod-tg"
}

resource "aws_clowdwatch_log_group" "this" {
  name              = "/ecs/ci-cd-app"
  retention_in_days = 7
}


resource "aws_ecs_service" "this" {
  name            = "app-service"
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 3
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.foo.arn
    container_name   = "ci-cd-app"
    container_port   = 8000
  }

}

resource "aws_ecs_task_definition" "this" {
  family                   = "app-ci-cd"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = <<TASK_DEFINITION
[
  {
      "containerDefinitions": [
          {
              "name": "ci-cd-app",
              "image": "gersontpc/ci-cd-app:v1.0.0",
              "cpu": 0,
              "portMappings": [
                  {
                      "name": "port-8000",
                      "containerPort": 8000,
                      "hostPort": 8000,
                      "protocol": "tcp",
                      "appProtocol": "http"
                  }
              ],
              "essential": true,
              "environment": [],
              "environmentFiles": [],
              "mountPoints": [],
              "volumesFrom": [],
              "ulimits": [],
              "logConfiguration": {
                  "logDriver": "awslogs",
                  "options": {
                      "awslogs-group": "/ecs/ci-cd-app",
                      "mode": "non-blocking",
                      "awslogs-create-group": "true",
                      "max-buffer-size": "25m",
                      "awslogs-region": "us-east-1",
                      "awslogs-stream-prefix": "ecs"
                  },
                  "secretOptions": []
              },
              "systemControls": [],
              "healthCheck": {
                  "command": ["CMD-SHELL", "curl -f http://0.0.0.0:8000 || exit 1"],
                  "interval": 15,
                  "timeout": 5,
                  "retries": 3,
                  "startPeriod": 20
              }
          }
      ],
      "family": "ci-cd-app",
      "taskRoleArn": "arn:aws:iam::526926919628:role/LabRole",
      "executionRoleArn": "arn:aws:iam::526926919628:role/LabRole",
      "networkMode": "awsvpc",
      "volumes": [],
      "placementConstraints": [],
      "requiresCompatibilities": [
          "FARGATE"
      ],
      "cpu": "512",
      "memory": "1024",
      "runtimePlatform": {
          "cpuArchitecture": "X86_64",
          "operatingSystemFamily": "LINUX"
      },
      "tags": [
          {
              "key": "Name",
              "value": "ci-cd-app"
          }
      ]
  }
]
TASK_DEFINITION

}

