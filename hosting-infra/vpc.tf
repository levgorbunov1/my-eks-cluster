# VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Internet gateways
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id
}

resource "aws_eip" "nat" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-eu-west-2c.id

  depends_on = [aws_internet_gateway.igw]
}

# Subnets
resource "aws_subnet" "private-eu-west-2a" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.0.0/19"
  availability_zone = "eu-west-2a"
}

resource "aws_subnet" "private-eu-west-2b" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = "eu-west-2b"
}

resource "aws_subnet" "public-eu-west-2c" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = "eu-west-2c"
  map_public_ip_on_launch = true
}

# Route tables
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "private-eu-west-2a" {
  subnet_id      = aws_subnet.private-eu-west-2a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-eu-west-2b" {
  subnet_id      = aws_subnet.private-eu-west-2b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public-eu-west-2c" {
  subnet_id      = aws_subnet.public-eu-west-2c.id
  route_table_id = aws_route_table.public.id
}
