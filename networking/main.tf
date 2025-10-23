variable "vpc_cidr" {}
variable "vpc_name" {}
variable "cidr_public_subnet" {}
variable "cidr_private_subnet" {}
variable "eu_availability_zone" {}

output "free_iliad_vpc_id" {
  value = aws_vpc.free_iliad_vpc_eu_central_1.id
}

output "free_iliad_public_subnets" {
  value = aws_subnet.free_iliad_public_subnets.*.id
}

output "public_subnet_cidr_block" {
  value = aws_subnet.free_iliad_public_subnets.*.cidr_block
}

output "free_iliad_private_subnets" {
  value = aws_subnet.free_iliad_private_subnets.*.id
}

output "private_subnet_cidr_block" {
  value = aws_subnet.free_iliad_private_subnets.*.cidr_block
}


# Setup VPC
resource "aws_vpc" "free_iliad_vpc_eu_central_1" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}


# Setup public subnet
resource "aws_subnet" "free_iliad_public_subnets" {
  count             = length(var.cidr_public_subnet)
  vpc_id            = aws_vpc.free_iliad_vpc_eu_central_1.id
  cidr_block        = element(var.cidr_public_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)

  tags = {
    Name = "free-iliad-public-subnet-${count.index + 1}"
  }
}

# Setup private subnet
resource "aws_subnet" "free_iliad_private_subnets" {
  count             = length(var.cidr_private_subnet)
  vpc_id            = aws_vpc.free_iliad_vpc_eu_central_1.id
  cidr_block        = element(var.cidr_private_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)

  tags = {
    Name = "free-iliad-private-subnet-${count.index + 1}"
  }
}

# Setup Internet Gateway
resource "aws_internet_gateway" "free_iliad_public_internet_gateway" {
  vpc_id = aws_vpc.free_iliad_vpc_eu_central_1.id
  tags = {
    Name = "free-iliad-igw"
  }
}

# Public Route Table
resource "aws_route_table" "free_iliad_public_route_table" {
  vpc_id = aws_vpc.free_iliad_vpc_eu_central_1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.free_iliad_public_internet_gateway.id
  }
  tags = {
    Name = "free-iliad-public-rt"
  }
}

# Public Route Table and Public Subnet Association
resource "aws_route_table_association" "free_iliad_public_rt_subnet_association" {
  count          = length(aws_subnet.free_iliad_public_subnets)
  subnet_id      = aws_subnet.free_iliad_public_subnets[count.index].id
  route_table_id = aws_route_table.free_iliad_public_route_table.id
}

# Setup Elastic IP
resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"
}



# Setup NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.free_iliad_public_subnets[0].id
  tags = {
    Name = "free-iliad-nat-gw"
  }
}


# Private Route Table
resource "aws_route_table" "free_iliad_private_subnets" {
  vpc_id = aws_vpc.free_iliad_vpc_eu_central_1.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  #depends_on = [aws_nat_gateway.nat_gateway]
  tags = {
    Name = "free-iliad-private-rt"
  }
}

# Private Route Table and private Subnet Association
resource "aws_route_table_association" "free_iliad_private_rt_subnet_association" {
  count          = length(aws_subnet.free_iliad_private_subnets)
  subnet_id      = aws_subnet.free_iliad_private_subnets[count.index].id
  route_table_id = aws_route_table.free_iliad_private_subnets.id
}



