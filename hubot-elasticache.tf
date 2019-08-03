resource "aws_security_group" "hubot-redis-sg" {
  name        = "hubot-redis-sg"
  description = "Terraform Managed. Allow Hubot traffic to Redis instance"
  vpc_id      = var.vpc_id

  tags = {
    Name       = "hubot-redis-sg"
    Project    = "hubot"
    tf-managed = "True"
  }

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.hubot-instance-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_subnet_group" "hubot-redis-subnet-group" {
  name       = "tf-redis-subnet-group-int"
  subnet_ids = var.private_subnet_ids
}

resource "aws_elasticache_cluster" "hubot-redis" {
  cluster_id           = "tf-hubot-brain"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  port                 = 6379
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  security_group_ids   = [aws_security_group.hubot-redis-sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.hubot-redis-subnet-group.name
}

