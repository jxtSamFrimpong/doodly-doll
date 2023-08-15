output "vpc" {
  value = {
    "id"  = aws_vpc.main.id
    "arn" = aws_vpc.main.arn

  }
}

output "igw" {
  value = {
    "arn" = aws_internet_gateway.main.arn
  }
}

output "azs" {
  value = {
    "name"     = data.aws_availability_zones.available.names
    "zone_ids" = data.aws_availability_zones.available.zone_ids
  }
}

output "route_tables" {
  value = {
    "public" = {
      "arn"   = aws_route_table.public.arn
      "id"    = aws_route_table.public.id
      "route" = aws_route_table.public.route
    }
    "private" = {
      "arn"   = aws_route_table.private.arn
      "id"    = aws_route_table.private.id
      "route" = aws_route_table.private.route
    }
  }
}

output "subnets" {
  value = {
    "public" = {
      "availability_zone_id" = aws_subnet.public_subnets[*].availability_zone_id
      "cidr_block"           = aws_subnet.public_subnets[*].cidr_block
      "id"                   = aws_subnet.public_subnets[*].id
      "arn"                  = aws_subnet.public_subnets[*].arn
    }
    "private" = {
      "availability_zone_id" = aws_subnet.private_subnets[*].availability_zone_id
      "cidr_block"           = aws_subnet.private_subnets[*].cidr_block
      "id"                   = aws_subnet.private_subnets[*].id
      "arn"                  = aws_subnet.private_subnets[*].arn
    }
  }
}

output "nacl" {
  value = {
    "private" = {
      "id"         = aws_network_acl.private.id
      "arn"        = aws_network_acl.private.arn
      "subnet_ids" = aws_network_acl.private.subnet_ids
      "ingress"    = aws_network_acl.private.ingress
      "egress"     = aws_network_acl.private.egress
    }
    "public" = {
      "id"         = aws_network_acl.public.id
      "arn"        = aws_network_acl.public.arn
      "subnet_ids" = aws_network_acl.public.subnet_ids
      "ingress"    = aws_network_acl.public.ingress
      "egress"     = aws_network_acl.public.egress
    }
  }
}
