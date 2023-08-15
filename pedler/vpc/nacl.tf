locals {
  allowed_ips_ingress = { for idx, val in concat(var.aws_network_acl["ingress"], [{
    "action"  = "allow"
    "rule_no" = 1
    "cidr"    = var.vpc_conf["cidr"]
  }]) : idx => val }
  allowed_ips_egress = { for idx, val in concat(var.aws_network_acl["egress"], [{
    "action"  = "allow"
    "rule_no" = 1
    "cidr"    = var.vpc_conf["cidr"]
  }]) : idx => val }
}

resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol   = "tcp"
    rule_no    = 1
    action     = "allow"
    cidr_block = var.vpc_conf["cidr"]
    from_port  = 0
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 1
    action     = "allow"
    cidr_block = var.vpc_conf["cidr"]
    from_port  = 0
    to_port    = 65535
  }

  tags       = var.tags
  depends_on = [aws_vpc.main, aws_subnet.private_subnets, aws_subnet.public_subnets]
}

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = local.allowed_ips_ingress # var.aws_network_acl["ingress"]
    content {
      protocol   = lookup(ingress.value, "protocol", "tcp")
      rule_no    = ingress.value["rule_no"]
      action     = lookup(ingress.value, "action", "allow")
      cidr_block = ingress.value["cidr"]
      from_port  = lookup(ingress.value, "from_port", 0)
      to_port    = lookup(ingress.value, "to_port", 65535)
    }
  }

  dynamic "egress" {
    for_each = local.allowed_ips_egress #var.aws_network_acl["egress"]

    content {
      protocol   = lookup(egress.value, "protocol", "tcp")
      rule_no    = egress.value["rule_no"]
      action     = lookup(egress.value, "action", "allow")
      cidr_block = egress.value["cidr"]
      from_port  = lookup(egress.value, "from_port", 0)
      to_port    = lookup(egress.value, "to_port", 65535)
    }
  }

  tags       = var.tags
  depends_on = [aws_vpc.main, aws_subnet.private_subnets, aws_subnet.public_subnets]
}

resource "aws_network_acl_association" "public" {
  for_each       = { for idx, val in aws_subnet.public_subnets[*].id : idx => val }
  subnet_id      = each.value
  network_acl_id = aws_network_acl.public.id

  depends_on = [aws_subnet.public_subnets, aws_network_acl.public]

}

resource "aws_network_acl_association" "private" {
  for_each       = { for idx, val in aws_subnet.private_subnets[*].id : idx => val }
  subnet_id      = each.value
  network_acl_id = aws_network_acl.private.id

  depends_on = [aws_subnet.private_subnets, aws_network_acl.private]
}
