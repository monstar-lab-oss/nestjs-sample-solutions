# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.env}-${var.project_name}"
    Env  = var.env
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.public_subnet_a_cidr
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "${var.env}-public-${var.project_name}-a"
    Env  = var.env
  }
}

resource "aws_subnet" "public_subnet_c" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.public_subnet_c_cidr
  availability_zone = "${var.aws_region}c"

  tags = {
    Name = "${var.env}-public-${var.project_name}-c"
    Env  = var.env
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "${var.env}-private-${var.project_name}-a"
    Env  = var.env
  }
}

resource "aws_subnet" "private_subnet_c" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.private_subnet_c_cidr
  availability_zone = "${var.aws_region}c"

  tags = {
    Name = "${var.env}-private-${var.project_name}-c"
    Env  = var.env
  }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

resource "aws_route_table_association" "public-a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_vpc.default.main_route_table_id
}

resource "aws_route_table_association" "public-b" {
  subnet_id      = aws_subnet.public_subnet_c.id
  route_table_id = aws_vpc.default.main_route_table_id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.default.id
}

resource "aws_route_table_association" "private-a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private-c" {
  subnet_id      = aws_subnet.private_subnet_c.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_eip" "nat" {
  tags = {
    "Env" = var.env
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "${var.env}-${var.project_name}-nat-gw"
  }
}

resource "aws_route" "nat_gw" {
  route_table_id         = aws_route_table.private_route_table.id
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
  destination_cidr_block = "0.0.0.0/0"
}
