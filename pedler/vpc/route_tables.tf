resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  #   route {
  #     cidr_block = "0.0.0.0/0"
  #     gateway_id = aws_internet_gateway.main.id
  #   }

  tags = merge({
    Name = "rtb-public-route-table"
    },
  var.tags)
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  #target
  gateway_id = aws_internet_gateway.main.id

  depends_on = [aws_route_table.public]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge({
    Name = "rtb-private-route-table"
    },
  var.tags)
}

resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id

  depends_on = [aws_subnet.public_subnets]
}

resource "aws_route_table_association" "private_subnet_asso" {
  #   for_each = {
  #     for id in aws_subnet.private_subnets[*].id :
  #     id => id
  #   }
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private.id

  depends_on = [aws_subnet.private_subnets]
}
