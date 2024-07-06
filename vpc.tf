provider "aws" {
  region = "us-west-2"
}

#VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "my-vpc-esp-2024"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-igw-esp-2024"
  }
}

#Subredes públicas
resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.main.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "us-west-2a"

  tags = {
    Name = "public_subnet_1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id = aws_vpc.main.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "us-west-2b"

  tags = {
    Name = "public_subnet_2"
  }
}

#Subredes privadas
resource "aws_subnet" "private_1" {
  vpc_id = aws_vpc.main.id
  cidr_block        = "10.0.128.0/20"
  availability_zone = "us-west-2a"

  tags = {
    Name = "private_subnet_1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id = aws_vpc.main.id
  cidr_block        = "10.0.144.0/20"
  availability_zone = "us-west-2b"

  tags = {
    Name = "private_subnet_2"
  }
}

# Tabla para subredes públicas
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Tabla para subredes privadas
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

