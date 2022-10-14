# You can ignore this file, not relevant to the current topic
# I am only creating the network from scratch to make sure I am only 
# interacting to a different network.
#
# Mostly, network is already there and done by network team, you just need to use "data" blocks 
# to get the specifics of the networks such as VPC, Subnets, and so on.

resource "aws_vpc" "myvpc" {
  cidr_block = "10.20.20.0/26"
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#enable_dns_support
  enable_dns_support = true
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#enable_dns_hostnames
  enable_dns_hostnames = true
  tags = {
    "Name" = "${local.common_name}-vpc"
  }
}

resource "aws_subnet" "private-1a" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.20.20.0/28"
  availability_zone = "${var.aws_region}a"
  tags = {
    "Name" = "${local.common_name}-private-1a"
  }
}

resource "aws_subnet" "private-1b" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.20.20.16/28"
  availability_zone = "${var.aws_region}b"
  tags = {
    "Name" = "${local.common_name}-private-1b"
  }
}

resource "aws_route_table" "myrt" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    "Name" = "${local.common_name}-route-table"
  }
}

resource "aws_route_table_association" "private-1a" {
  subnet_id      = aws_subnet.private-1a.id
  route_table_id = aws_route_table.myrt.id
}

resource "aws_route_table_association" "private-1b" {
  subnet_id      = aws_subnet.private-1b.id
  route_table_id = aws_route_table.myrt.id
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    "Name" = "${local.common_name}-gateway"
  }
}
resource "aws_route" "internet-route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.myrt.id
  gateway_id             = aws_internet_gateway.myigw.id
}