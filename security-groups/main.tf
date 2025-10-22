variable "ec2_clickhouse_sg_name" {}
variable "vpc_id" {}
variable "ec2_jump_server_sg_name" {}

output "sg_ec2_jump_server" {
  value = aws_security_group.ec2_jump_server.id
}

output "sg_ec2_clickhouse_instances" {
  value = aws_security_group.ec2_clickhouse_instances.id
}

resource "aws_security_group" "ec2_jump_server" {
  name        = var.ec2_jump_server_sg_name
  description = "Enable the Port 22 (SSH)"
  vpc_id      = var.vpc_id

  # ssh for terraform remote exec
  ingress {
    description = "Allow remote SSH from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }


  #Outgoing request
  egress {
    description = "Allow outgoing request"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security Groups to allow SSH(22)"
  }
}

resource "aws_security_group" "ec2_clickhouse_instances" {
  name        = var.ec2_clickhouse_sg_name
  description = "Security group for clickhouse (srvers & keepers )"
  vpc_id      = var.vpc_id

  # ssh for terraform remote exec
  ingress {
    description = "Allow all ports from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    Name = "Security Groups to allow clickhouse (servers & keepers) ports"
  }
}

