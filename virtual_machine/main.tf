variable "ami_id" {}
variable "instance_type" {}
variable "tag_name" {}
variable "public_key" {}
variable "subnet_id" {}
variable "sg_for_jump_server" {}
variable "enable_public_ip_address" {}
variable "user_data_install_jump_server" {}

output "ssh_connection_string_for_ec2" {
  value = format("%s%s", "ssh -i /Users/rahulwagh/.ssh/aws_ec2_terraform ubuntu@", aws_instance.jump_server_ec2_instance_ip.public_ip)
}

output "jump_server_ec2_instance_id" {
  value = aws_instance.jump_server_ec2_instance_ip.id
}

output "jump_server_ec2_instance_public_ip" {
  value = aws_instance.jump_server_ec2_instance_ip.public_ip
}

resource "aws_instance" "jump_server_ec2_instance_ip" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.tag_name
  }
  key_name                    = aws_key_pair.jump_server_ec2_instance_public_key.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.sg_for_jump_server
  associate_public_ip_address = var.enable_public_ip_address

  user_data = var.user_data_install_jump_server

  metadata_options {
    http_endpoint = "enabled"  # Enable the IMDSv2 endpoint
    http_tokens   = "required" # Require the use of IMDSv2 tokens
  }
}

resource "aws_key_pair" "jump_server_ec2_instance_public_key" {
  key_name   = "aws_ec2_terraform_${var.tag_name}"
  public_key = var.public_key
}
