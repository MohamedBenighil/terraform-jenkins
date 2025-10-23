module "networking" {
  source               = "./networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  cidr_public_subnet   = var.cidr_public_subnet
  eu_availability_zone = var.eu_availability_zone
  cidr_private_subnet  = var.cidr_private_subnet
}

module "security_group" {
  source                  = "./security-groups"
  ec2_jump_server_sg_name = "SG for EC2 instance (jump server)"
  vpc_id                  = module.networking.free_iliad_vpc_id
  ec2_clickhouse_sg_name  = "SG for EC2 instances clickhouse (servers & keepers)"
}


module "virtual_machine" {
  source        = "./virtual_machine"
  ami_id        = var.ec2_ami_id
  instance_type = "t3.micro"

  for_each                      = toset(var.vms_names)
  public_key                    = var.public_key
  tag_name                      = each.key
  enable_public_ip_address      = each.key == "jump-server" ? true : false
  sg_for_jump_server            = each.key == "jump-server" ? [module.security_group.sg_ec2_jump_server] : [module.security_group.sg_ec2_clickhouse_instances]
  subnet_id                     = each.key == "jump-server" ? tolist(module.networking.free_iliad_public_subnets)[0] : tolist(module.networking.free_iliad_private_subnets)[0]
  user_data_install_jump_server = templatefile("./jump-server-script/installer.sh", { hostname = each.key })
}


module "hosted_zone" {
  source      = "./hosted-zone"
  vpc_id      = module.networking.free_iliad_vpc_id
  domain_name = "free-iliad.com"
  records = {
    for vm_name, vm in module.virtual_machine :
    vm_name => vm.jump_server_ec2_instance_private_ip
  }
}


