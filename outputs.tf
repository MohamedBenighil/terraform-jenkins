output "jump_server_connection_string" {
  value = format("%s%s", "ssh -i ../.ssh/insecure_private_key ubuntu@", module.virtual_machine["jump-server"].jump_server_ec2_instance_public_ip)
}
