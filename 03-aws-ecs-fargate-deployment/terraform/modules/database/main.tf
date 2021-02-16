resource "aws_db_subnet_group" "default" {
  name       = "${var.env}-${var.project_name}-aurora-cluster-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Env = var.env
  }
}

resource "aws_security_group" "aurora-cluster" {
  name   = "${var.env}-${var.project_name}-aurora-cluster-security-group"
  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Env = var.env
  }
}

resource "aws_rds_cluster_parameter_group" "default" {
  name        = "${var.env}-${var.project_name}-backend-mysql"
  family      = "aurora-mysql5.7"
  description = "Parameter group for ${var.env}-${var.project_name} mysql aurora cluster"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_connection"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_filesystem"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_results"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_connection"
    value = "utf8mb4_unicode_ci"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
  }
}

resource "aws_rds_cluster" "default" {
  cluster_identifier              = "${var.env}-${var.project_name}-aurora-cluster"
  engine                          = "aurora-mysql"
  engine_version                  = "5.7.mysql_aurora.2.08.2"
  database_name                   = var.db_name
  master_username                 = var.username
  master_password                 = var.password
  db_subnet_group_name            = aws_db_subnet_group.default.name
  vpc_security_group_ids          = [aws_security_group.aurora-cluster.id]
  final_snapshot_identifier       = "${var.env}-${var.project_name}-aurora-cluster-snapshot-${md5(timestamp())}"
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.default.id

  tags = {
    Env = var.env
  }
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count                = var.instance_count
  identifier           = "${var.env}-${var.project_name}-aurora-cluster-${count.index}"
  cluster_identifier   = aws_rds_cluster.default.id
  instance_class       = var.instance_class
  engine               = aws_rds_cluster.default.engine
  engine_version       = aws_rds_cluster.default.engine_version
  db_subnet_group_name = aws_db_subnet_group.default.name

  tags = {
    Env = var.env
  }
}
