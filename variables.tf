# variable "bucket_name" {
#   type        = string
#   description = "Remote state bucket name"
# }

variable "vpc_cidr" {
  type        = string
  description = "Public Subnet CIDR values"
}

variable "vpc_name" {
  type        = string
  description = "Free Iliad VPC 1"
}

variable "cidr_public_subnet" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "cidr_private_subnet" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "eu_availability_zone" {
  type        = list(string)
  description = "Availability Zones"
}

variable "public_key" {
  type        = string
  description = "Free Iliad Public key for EC2 instances"
}

variable "ec2_ami_id" {
  type        = string
  description = "Free Iliad AMI Id for EC2 instances"
}

variable "vms_names" {
  type = list(string)
  # default = ["jump-server", "clickhouse-01", "clickhouse-02", "clickhouse-03", "clickhouse-04", "clickhouse-keeper-01", "clickhouse-keeper-02", "clickhouse-keeper-03"]
  default = ["jump-server", "clickhouse-01", "clickhouse-02"]
}
