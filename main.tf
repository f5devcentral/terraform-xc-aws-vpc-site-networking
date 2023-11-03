resource "random_string" "random" {
  length  = 8
  special = false
  numeric = false
  lower   = true
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  create_vpc                = (null == var.existing_vpc_id)
  create_outside_subnet     = local.outside_subnets_len > 0
  create_local_subnet       = local.local_subnets_len > 0
  create_inside_subnet      = local.inside_subnets_len > 0
  create_workload_subnet    = local.workload_subnets_len > 0
  outside_subnets_len       = length(var.outside_subnets)
  local_subnets_len         = length(var.local_subnets)
  inside_subnets_len        = length(var.inside_subnets)
  workload_subnets_len      = length(var.workload_subnets)
  vpc_name                  = var.name != null ? var.name : format("%s-vpc", random_string.random.result)
  vpc_id                    = var.existing_vpc_id != null ? var.existing_vpc_id : aws_vpc.this[0].id
  az_names                  = length(var.az_names) > 0 ? var.az_names : slice(data.aws_availability_zones.available.names, 0, max(local.outside_subnets_len, local.local_subnets_len, local.inside_subnets_len, local.workload_subnets_len))
}

resource "aws_vpc" "this" {
  count = local.create_vpc ? 1 : 0

  cidr_block                           = var.vpc_cidr
  instance_tenancy                     = var.vpc_instance_tenancy
  enable_dns_hostnames                 = var.vpc_enable_dns_hostnames
  enable_dns_support                   = var.vpc_enable_dns_support
  enable_network_address_usage_metrics = var.vpc_enable_network_address_usage_metrics

  tags = merge(
    { 
      Name = local.vpc_name
    },
    var.tags,
  )
}

resource "aws_subnet" "outside" {
  count = local.create_outside_subnet ? local.outside_subnets_len : 0

  availability_zone = element(local.az_names, count.index)
  cidr_block        = element(var.outside_subnets, count.index)
  vpc_id            = local.vpc_id

  tags = merge(
    {
      Name = format("%s-outside-%s", local.vpc_name, element(local.az_names, count.index))
    },
    var.tags,
  )

  depends_on = [
    aws_vpc.this,
  ]
}

resource "aws_subnet" "local" {
  count = local.create_local_subnet ? local.local_subnets_len : 0

  availability_zone = element(local.az_names, count.index)
  cidr_block        = element(var.local_subnets, count.index)
  vpc_id            = local.vpc_id

  tags = merge(
    {
      Name = format("%s-local-%s", local.vpc_name, element(local.az_names, count.index))
    },
    var.tags,
  )

  depends_on = [
    aws_vpc.this,
  ]
}

resource "aws_subnet" "inside" {
  count = local.create_inside_subnet ? local.inside_subnets_len : 0

  availability_zone = element(local.az_names, count.index)
  cidr_block        = element(var.inside_subnets, count.index)
  vpc_id            = local.vpc_id

  tags = merge(
    {
      Name = format("%s-inside-%s", local.vpc_name, element(local.az_names, count.index))
    },
    var.tags,
  )

  depends_on = [ 
    aws_vpc.this,
   ]
}

resource "aws_subnet" "workload" {
  count = local.create_workload_subnet ? local.workload_subnets_len : 0

  availability_zone = element(local.az_names, count.index)
  cidr_block        = element(var.workload_subnets, count.index)
  vpc_id            = local.vpc_id

  tags = merge(
    {
      Name = format("%s-workload-%s", local.vpc_name, element(local.az_names, count.index))
    },
    var.tags,
  )

  depends_on = [ 
    aws_vpc.this,
   ]
}

resource "aws_route_table" "outside" {
  count = var.create_outside_route_table && (null != var.outside_subnets || null != var.local_subnets) ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    { 
      Name = format("%s-outside-rt", local.vpc_name)
    },
    var.tags,
  )

  depends_on = [ 
    aws_vpc.this,
  ]
}

resource "aws_route_table_association" "outside" {
  count = var.create_outside_route_table ? local.outside_subnets_len : 0

  subnet_id      = element(aws_subnet.outside[*].id, count.index)
  route_table_id = aws_route_table.outside[0].id
}

resource "aws_route_table_association" "local" {
  count = var.create_outside_route_table ? local.local_subnets_len : 0

  subnet_id      = element(aws_subnet.local[*].id, count.index)
  route_table_id = aws_route_table.outside[0].id
}

resource "aws_route" "internet_gateway" {
  count = var.create_internet_gateway ? 1 : 0

  route_table_id         = aws_route_table.outside[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_internet_gateway" "this" {
  count = var.create_internet_gateway ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    { 
      Name = format("%s-igw", local.vpc_name)
    },
    var.tags,
  )

  depends_on = [
    aws_vpc.this,
  ]
}

resource "aws_default_security_group" "default" {
  count = local.create_vpc ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    {
      Name = format("%s-default-sg", local.vpc_name)
    },
    var.tags,
  )

  depends_on = [ 
    aws_vpc.this,
  ]
}

module "aws_vpc_sg" {
  source = "./modules/aws-sg"

  vpc_id = local.vpc_id
  prefix = local.vpc_name

  create_inside_security_group    = var.create_inside_security_group
  create_outside_security_group   = var.create_outside_security_group
  create_udp_security_group_rules = var.create_udp_security_group_rules


  depends_on = [
    aws_vpc.this,
  ]
}