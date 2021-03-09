// CODE BUILD

resource "aws_iam_role" "codebuild_role" {
  name = "${var.env}-${var.project_name}-codebuild-backend"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_subnet" "private_subnet_a" {
  id = var.private_subnet_ids[0]
}

data "aws_subnet" "private_subnet_c" {
  id = var.private_subnet_ids[1]
}

resource "aws_iam_role_policy" "codebuild_role_policy" {
  role = aws_iam_role.codebuild_role.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterfacePermission"
      ],
      "Resource": [
        "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:network-interface/*"
      ],
      "Condition": {
        "StringEquals": {
          "ec2:Subnet": [
            "${data.aws_subnet.private_subnet_a.arn}",
            "${data.aws_subnet.private_subnet_c.arn}"
          ],
          "ec2:AuthorizedService": "codebuild.amazonaws.com"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_bucket.arn}",
        "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      ]
    },
    {
      "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetAuthorizationToken",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Effect": "Allow",
      "Action": [
          "ssm:GetParameters",
          "kms:Decrypt"
      ],
      "Resource": [
          "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.project_name}/${var.env}/*",
          "${data.aws_kms_alias.ssm_key.arn}"
      ]
    }
  ]
}
POLICY
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = var.vpc_id
}

resource "aws_codebuild_source_credential" "default" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.github_oauth_token
}

resource "aws_codebuild_project" "default" {
  name         = "${var.env}-${var.project_name}-backend"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:4.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/${var.github_repo_owner}/${var.github_repo_name}.git"
    git_clone_depth = 1

    auth {
      type     = "OAUTH"
      resource = aws_codebuild_source_credential.default.arn
    }

    buildspec = <<EOF
version: 0.2

env:
  parameter-store:
    DB_HOST: /${var.project_name}/${var.env}/backend/DB_HOST
    DB_PORT: /${var.project_name}/${var.env}/backend/DB_PORT
    DB_USER: /${var.project_name}/${var.env}/backend/DB_USER
    DB_PASS: /${var.project_name}/${var.env}/backend/DB_PASS
    DB_NAME: /${var.project_name}/${var.env}/backend/DB_NAME
    JWT_PUBLIC_KEY_BASE64: /${var.project_name}/${var.env}/backend/JWT_PUBLIC_KEY_BASE64
    JWT_PRIVATE_KEY_BASE64: /${var.project_name}/${var.env}/backend/JWT_PRIVATE_KEY_BASE64
    JWT_ACCESS_TOKEN_EXP_IN_SEC: /${var.project_name}/${var.env}/backend/JWT_ACCESS_TOKEN_EXP_IN_SEC
    JWT_REFRESH_TOKEN_EXP_IN_SEC: /${var.project_name}/${var.env}/backend/JWT_REFRESH_TOKEN_EXP_IN_SEC
    DEFAULT_ADMIN_USER_PASSWORD: /${var.project_name}/${var.env}/backend/DEFAULT_ADMIN_USER_PASSWORD

phases:
  install:
    commands:
      - echo Installing node modules required for migration
      - npm ci
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - $(aws ecr get-login --no-include-email --region ${var.aws_region})
  build:
    commands:
      - echo Build started on `date`
      - echo Building the Docker image...
      - docker build -t ${var.project_name}/${var.env}-backend:latest --build-arg APP_ENV=production .
      - docker tag ${var.project_name}/${var.env}-backend:latest ${aws_ecr_repository.default.repository_url}:latest
  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing the Docker image...
      - docker push ${aws_ecr_repository.default.repository_url}:latest
      - echo Writing image definitions file...
      - printf '[{"name":"%s","imageUri":"%s"}]' ${var.env}-${var.project_name}-backend ${aws_ecr_repository.default.repository_url}:latest > imagedefinitions.json
      - echo Running database migration
      - npm run migration:run
      - echo Running bootstrap cli
      - npm run cli:dev
artifacts:
    files: imagedefinitions.json
    EOF
  }

  source_version = var.source_version

  vpc_config {
    vpc_id = var.vpc_id

    subnets = var.private_subnet_ids

    security_group_ids = [
      data.aws_security_group.default.id
    ]
  }

  tags = {
    Env = var.env
  }
}

// CODE PIPELINE

resource "aws_codepipeline" "codepipeline" {
  name     = "${var.env}-${var.project_name}-backend"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner                = var.github_repo_owner
        Repo                 = var.github_repo_name
        Branch               = var.source_version
        OAuthToken           = var.github_oauth_token
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "${var.env}-${var.project_name}-backend"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ClusterName = "${var.env}-${var.project_name}"
        ServiceName = "backend"
      }
    }
  }

  depends_on = [aws_codebuild_project.default]
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.env}-${var.project_name}-codepipeline-backend"
  acl    = "private"

  tags = {
    Env = var.env
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name = "${var.env}-${var.project_name}-codepipeline-backend"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
          "iam:PassRole"
      ],
      "Resource": "*",
      "Effect": "Allow",
      "Condition": {
          "StringEqualsIfExists": {
              "iam:PassedToService": [
                  "ecs-tasks.amazonaws.com"
              ]
          }
      }
    },
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_bucket.arn}",
        "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
          "ecr:DescribeImages"
      ],
      "Resource": "*"
    },
    {
      "Action": [
          "elasticloadbalancing:*",
          "ecs:*"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

// GITHUB WEBHOOK

resource "aws_codepipeline_webhook" "default" {
  name            = "${var.env}-${var.project_name}-backend"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.codepipeline.name

  authentication_configuration {
    secret_token = var.github_webhook_secret
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}

resource "github_repository_webhook" "default" {
  repository = var.github_repo_name

  configuration {
    url          = aws_codepipeline_webhook.default.url
    content_type = "json"
    insecure_ssl = false
    secret       = var.github_webhook_secret
  }

  events = ["push"]
}
