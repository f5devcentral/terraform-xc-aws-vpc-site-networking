data "aws_vpc" "this" {
  id = var.vpc_id
}

locals {
  prefix = var.prefix != "" ? format("%s-", var.prefix) : ""
}

locals {
  americas_tcp_80_443_range = [
    "5.182.215.0/25",
    "84.54.61.0/25",
    "23.158.32.0/25",
    "84.54.62.0/25",
    "185.94.142.0/25",
    "185.94.143.0/25",
    "159.60.190.0/24",
    "159.60.168.0/24",
  ]
  europe_tcp_80_443_range = [
    "5.182.213.0/25",
    "5.182.212.0/25",
    "5.182.213.128/25",
    "5.182.214.0/25",
    "84.54.60.0/25",
    "185.56.154.0/25",
    "159.60.160.0/24",
    "159.60.162.0/24",
    "159.60.188.0/24",
  ]
  asia_tcp_80_443_range = [
    "103.135.56.0/25",
    "103.135.57.0/25",
    "103.135.56.128/25",
    "103.135.59.0/25",
    "103.135.58.128/25",
    "103.135.58.0/25",
    "159.60.189.0/24",
    "159.60.166.0/24",
    "159.60.164.0/24",
  ]
  americas_udp_4500_range = [
    "5.182.215.0/25",
    "84.54.61.0/25",
    "23.158.32.0/25",
    "84.54.62.0/25",
    "185.94.142.0/25",
    "185.94.143.0/25",
    "159.60.190.0/24",
  ]
  europe_udp_4500_range = [
    "5.182.213.0/25",
    "5.182.212.0/25",
    "5.182.213.128/25",
    "5.182.214.0/25",
    "84.54.60.0/25",
    "185.56.154.0/25",
    "159.60.160.0/24",
    "159.60.162.0/24",
    "159.60.188.0/24",
  ]
  asia_udp_4500_range = [
    "103.135.56.0/25",
    "103.135.57.0/25",
    "103.135.56.128/25",
    "103.135.59.0/25",
    "103.135.58.128/25",
    "103.135.58.0/25",
    "159.60.189.0/24",
    "159.60.166.0/24",
    "159.60.164.0/24",
  ]
}

resource "aws_ec2_managed_prefix_list" "tcp_80" {
  count = var.create_outside_security_group ? 1 : 0

  name           = "XC Cloud TCP 80 IPv4 Subnet Ranges"
  address_family = "IPv4"
  max_entries    = 30

  dynamic "entry" {
    for_each =local.americas_tcp_80_443_range
    content {
      description = "Americas IPv4 Subnet Ranges"
      cidr        = entry.value
    }
  }

  dynamic "entry" {
    for_each = local.europe_tcp_80_443_range
    content {
      description = "Europe IPv4 Subnet Ranges"
      cidr        = entry.value
    }
  }

  dynamic "entry" {
    for_each = local.asia_tcp_80_443_range
    content {
      description = "Asia IPv4 Subnet Ranges"
      cidr        = entry.value
    }
  }

  tags = var.tags
}

resource "aws_ec2_managed_prefix_list" "tcp_443" {
  count = var.create_outside_security_group ? 1 : 0
  
  name           = "XC Cloud TCP 443 IPv4 Subnet Ranges"
  address_family = "IPv4"
  max_entries    = 30

  dynamic "entry" {
    for_each = local.americas_tcp_80_443_range
    content {
      description = "Americas IPv4 Subnet Ranges"
      cidr        = entry.value
    }
  }

  dynamic "entry" {
    for_each = local.europe_tcp_80_443_range
    content {
      description = "Europe IPv4 Subnet Ranges"
      cidr        = entry.value
    }
  }

  dynamic "entry" {
    for_each = local.asia_tcp_80_443_range
    content {
      description = "Asia IPv4 Subnet Ranges"
      cidr        = entry.value
    }
  }

  tags = var.tags
}

resource "aws_ec2_managed_prefix_list" "udp_4500" {
  count = var.create_outside_security_group && var.create_udp_security_group_rules ? 1 : 0

  name           = "XC Cloud UDP 4500 IPv4 Subnet Ranges"
  address_family = "IPv4"
  max_entries    = 30

  dynamic "entry" {
    for_each = local.americas_udp_4500_range
    content {
      description = "Americas IPv4 Subnet Ranges"
      cidr        = entry.value
    }
  }

  dynamic "entry" {
    for_each = local.europe_udp_4500_range
    content {
      description = "Europe IPv4 Subnet Ranges"
      cidr        = entry.value
    }
  }

  dynamic "entry" {
    for_each = local.asia_udp_4500_range
    content {
      description = "Asia IPv4 Subnet Ranges"
      cidr        = entry.value
    }
  }

  tags = var.tags
}

resource "aws_security_group" "outside" {
  count = var.create_outside_security_group ? 1 : 0

  description = "Outside security group"
  vpc_id      = var.vpc_id
  name        = format("%soutside-sg", local.prefix)

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "Local traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ data.aws_vpc.this.cidr_block ]
  }

  ingress {
    description     = "TCP 80 IPv4 Subnet Ranges"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    prefix_list_ids = [ aws_ec2_managed_prefix_list.tcp_80[0].id ]
  }

  ingress {
    description = "TCP 443 IPv4 Subnet Ranges"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    prefix_list_ids = [ aws_ec2_managed_prefix_list.tcp_443[0].id ]
  }

  dynamic "ingress" {
    for_each = var.create_udp_security_group_rules ? [0] : []

    content {
      description = "UDP 4500 IPv4 Subnet Ranges"
      from_port   = 4500
      to_port     = 4500
      protocol    = "udp"
      prefix_list_ids = [ aws_ec2_managed_prefix_list.udp_4500[0].id ]
    }
  }

  tags = merge(
    {
      Name = format("%soutside-sg", local.prefix)
    },
    var.tags,
  )
}

resource "aws_security_group" "inside" {
  count = var.create_inside_security_group ? 1 : 0

  description = "Inside security group for"
  vpc_id      = var.vpc_id
  name        = format("%sinside-sg", local.prefix)

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [ data.aws_vpc.this.cidr_block ]
  }

  tags = merge(
    {
      Name = format("%sinside-sg", local.prefix)
    },
    var.tags,
  )
}