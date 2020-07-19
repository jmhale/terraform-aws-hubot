## Requires a Slack API key to be stored in AWS SSM Parameter Store as hubot-slack-token
resource "aws_security_group" "hubot-instance-sg" {
  name        = "hubot-instance-sg"
  description = "Terraform Managed. Hubot instance."
  vpc_id      = var.vpc_id

  tags = {
    Name       = "hubot-instance-sg"
    Project    = "hubot"
    tf-managed = "True"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "hubot-instance" {
  ami                    = var.ami_id
  instance_type          = "t2.nano"
  key_name               = var.ssh_key_id
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.hubot-instance-sg.id, var.ingress_security_group_id]
  iam_instance_profile   = aws_iam_instance_profile.access-hubot-parameters-profile.name

  user_data = <<EOF
#!/bin/bash
apt-get update
apt-get upgrade
apt-get install -y awscli python-pip jq npm nodejs
pip install botocore --upgrade
pip install boto3 --upgrade
npm install -g yo generator-hubot
echo HUBOT_DISCORD_TOKEN=$(aws --region us-east-1 ssm get-parameter --name hubot-discord-token --with-decryption | jq -r '.Parameter.Value') | sudo tee -a /etc/environment
echo REDIS_URL=redis://${aws_elasticache_cluster.hubot-redis.cache_nodes[0].address}:6379/dogbot | sudo tee -a /etc/environment
git clone --single-branch --branch v2 https://github.com/jmhale/dogbot.git /home/ubuntu/dogbot
chown -R ubuntu:ubuntu /home/ubuntu/dogbot
echo ${filebase64("${path.module}/hubot.service")} | base64 --decode > /etc/systemd/system/hubot.service
systemctl daemon-reload
systemctl enable hubot
systemctl start hubot
EOF


  tags = {
    Name       = "hubot-dogbot"
    Project    = "hubot"
    tf-managed = "True"
  }
}

resource "aws_eip" "hubot_eip" {
  instance = aws_instance.hubot-instance.id
  vpc      = true
}

