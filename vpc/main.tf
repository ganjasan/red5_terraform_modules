#VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name  = "${var.project_name}_vpc"
    App   = var.project_name
    Stage = var.stage
  }
}

#Public Subnets
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.availability_zone_a
  cidr_block              = var.public_subnet_cidr_a
  map_public_ip_on_launch = true

  tags = {
    Name  = "${var.project_name}_public_subnet_a"
    App   = var.project_name
    Stage = var.stage
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.availability_zone_b
  cidr_block              = var.public_subnet_cidr_b
  map_public_ip_on_launch = true

  tags = {
    Name  = "${var.project_name}_public_subnet_b"
    App   = var.project_name
    Stage = var.stage
  }
}

#Internet GW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name  = "${var.project_name}_igw"
    App   = var.project_name
    Stage = var.stage
  }
}

#Public Route Tables
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name  = "${var.project_name}_public_route_table"
    App   = var.project_name
    Stage = var.stage
  }
}

resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  depends_on = [
    aws_route_table.public_route_table
  ]
}

resource "aws_route_table_association" "public_subnet_a_association" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_b_association" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}

#Private Subnets
resource "aws_subnet" "private_subnet_a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet_cidr_a

  tags = {
    Name  = "${var.project_name}_private_subnet_a"
    App   = var.project_name
    Stage = var.stage
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet_cidr_b

  tags = {
    Name  = "${var.project_name}_private_subnet_b"
    App   = var.project_name
    Stage = var.stage
  }
}

#Private Route Tables

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name  = "${var.project_name}.private_route_table"
    App   = var.project_name
    Stage = var.stage
  }
}

resource "aws_route_table_association" "private_subnet_a_association" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_b_association" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_route_table.id
}


