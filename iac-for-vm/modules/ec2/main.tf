resource "aws_iam_role" "ec2_cloudwatch_role" {
  name = "${var.name}-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_attach" {
  role       = aws_iam_role.ec2_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.name}-cloudwatch-profile"
  role = aws_iam_role.ec2_cloudwatch_role.name
}

resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name

}

user_data = <<-EOF
              #!/bin/bash
              apt update -y
              
              # Install Ansible
              apt install -y software-properties-common
              add-apt-repository --yes --update ppa:ansible/ansible
              apt install -y ansible

              # Install CloudWatch Agent
              wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/arm64/latest/amazon-cloudwatch-agent.deb -O /tmp/amazon-cloudwatch-agent.deb
              dpkg -i /tmp/amazon-cloudwatch-agent.deb

              # Create log file path
              touch /var/log/webapp.log
              chmod 644 /var/log/webapp.log

              # Write CloudWatch config file
              cat <<EOC > /opt/aws/amazon-cloudwatch-agent/bin/config.json
              {
                "logs": {
                  "logs_collected": {
                    "files": {
                      "collect_list": [
                        {
                          "file_path": "/var/log/webapp.log",
                          "log_group_name": "/ec2/webapp",
                          "log_stream_name": "{instance_id}-webapp"
                        },
                        {
                          "file_path": "/var/log/syslog",
                          "log_group_name": "/ec2/syslog",
                          "log_stream_name": "{instance_id}-syslog"
                        }
                      ]
                    }
                  }
                }
              }
EOC

              # Start CloudWatch Agent
              /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
                -a fetch-config \
                -m ec2 \
                -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json \
                -s
EOF
