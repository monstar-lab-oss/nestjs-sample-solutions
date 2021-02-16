data "aws_caller_identity" "current" {}

resource "aws_ecr_repository" "default" {
  name                 = "${var.project_name}/${var.env}-backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Env = var.env
  }
}

resource "aws_ecs_cluster" "default" {
  name               = "${var.env}-${var.project_name}"
  capacity_providers = ["FARGATE"]

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.env}-${var.project_name}-ecs-task-execution-role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Env = var.env
  }
}

resource "aws_iam_role_policy" "ecs_task_execution_policy" {
  name = "${var.env}-${var.project_name}-ecs-task-execution-policy"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters",
        "secretsmanager:GetSecretValue",
        "kms:Decrypt"
      ],
      "Resource": [
        "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.project_name}/${var.env}/*",
        "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:*",
        "${data.aws_kms_alias.ssm_key.arn}"
      ]
    }
  ]
}
  EOF
}

resource "aws_cloudwatch_log_group" "backend" {
  name = "/ecs/${var.env}-${var.project_name}-backend"
}

resource "aws_ecs_task_definition" "backend" {
  family                   = "${var.env}-${var.project_name}-backend"
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = templatefile("${path.module}/container-definitions/backend.json", {
    env                              = var.env,
    region                           = var.aws_region,
    project_name                     = var.project_name,
    app_env_arn                      = aws_ssm_parameter.app_env.arn,
    app_port_arn                     = aws_ssm_parameter.app_port.arn,
    db_host_arn                      = aws_ssm_parameter.db_host.arn,
    db_name_arn                      = aws_ssm_parameter.db_name.arn,
    db_pass_arn                      = aws_ssm_parameter.db_pass.arn,
    db_port_arn                      = aws_ssm_parameter.db_port.arn,
    db_user_arn                      = aws_ssm_parameter.db_user.arn,
    jwt_access_token_exp_in_sec_arn  = aws_ssm_parameter.jwt_access_token_exp_in_sec.arn,
    jwt_refresh_token_exp_in_sec_arn = aws_ssm_parameter.jwt_refresh_token_exp_in_sec.arn,
    jwt_private_key_base64_arn       = aws_ssm_parameter.jwt_private_key_base64.arn,
    jwt_public_key_base64            = aws_ssm_parameter.jwt_public_key_base64.arn,
    default_admin_user_password      = aws_ssm_parameter.default_admin_user_password.arn,
    repository_url                   = aws_ecr_repository.default.repository_url,
    container_name                   = "${var.env}-${var.project_name}-backend"
  })

  tags = {
    Env = var.env
  }
}

resource "aws_security_group" "backend" {
  name        = "${var.env}-${var.project_name}-backend"
  description = "Security group for backend ${var.env}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "backend" {
  name                              = "backend"
  cluster                           = aws_ecs_cluster.default.id
  task_definition                   = "${var.env}-${var.project_name}-backend"
  desired_count                     = 1
  health_check_grace_period_seconds = 5
  launch_type                       = "FARGATE"
  depends_on                        = [aws_lb_target_group.backend, aws_ecs_task_definition.backend]

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = "${var.env}-${var.project_name}-backend"
    container_port   = 3000
  }

  network_configuration {
    assign_public_ip = false

    security_groups = [
      aws_security_group.backend.id
    ]

    subnets = var.private_subnet_ids
  }
}
