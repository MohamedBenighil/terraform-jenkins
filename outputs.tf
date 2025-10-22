output "jump_server_connection_string" {
  value = format("%s%s", "ssh -i ./.ssh/aws_ec2_terraform.pem ubuntu@", module.virtual_machine.jump_server_ec2_instance_public_ip)
}
