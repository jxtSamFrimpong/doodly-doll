locals {
  availability_zones = { for idx, val in range(length(var.subnet_cidrs["public"])) : idx => element(data.aws_availability_zones.available.names, idx) }
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.subnet_cidrs["public"])
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.subnet_cidrs["public"], count.index)
  availability_zone       = element(values(local.availability_zones), count.index) #element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = merge({
    Name = "Public-Subnet-${count.index + 1}"
    },
  var.tags)
}

resource "aws_subnet" "private_subnets" {
  count                   = length(var.subnet_cidrs["private"])
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.subnet_cidrs["private"], count.index)
  availability_zone       = element(values(local.availability_zones), count.index) #element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false

  tags = merge({
    Name = "Private-Subnet-${count.index + 1}"
    },
  var.tags)
}
