resource "aws_vpc" "master_vpc" {
  cidr_block = var.vpc_cidr
  tags = merge({ Name = "${var.name_prefix}-vpc" },
  var.aws_tags)
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "master" {
  count             = min(length(data.aws_availability_zones.available.names), var.min_az_count, var.max_az_count)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  vpc_id            = aws_vpc.master_vpc.id
  tags = merge({ Name = "${var.name_prefix}-subnet-${data.aws_availability_zones.available.names[count.index]}" },
  var.aws_tags)
}

resource "aws_internet_gateway" "master" {
  vpc_id = aws_vpc.master_vpc.id
  tags = merge({ Name = "${var.name_prefix}-igw" },
  var.aws_tags)
}

resource "aws_route_table" "master" {
  vpc_id = aws_vpc.master_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.master.id
  }
  tags = merge({ Name = "${var.name_prefix}-rt" },
  var.aws_tags)
}

resource "aws_route_table_association" "master" {
  count          = min(length(data.aws_availability_zones.available.names), var.min_az_count, var.max_az_count)
  subnet_id      = aws_subnet.master[count.index].id
  route_table_id = aws_route_table.master.id
}
