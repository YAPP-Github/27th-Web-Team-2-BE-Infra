##############################
# VPC
##############################
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = format("%s-vpc", var.environment)
    Environment = var.environment
  }
}

##############################
# Internet Gateway
##############################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = format("%s-igw", var.environment)
    Environment = var.environment
  }
}

##############################
# Public Subnets (A / C)
##############################

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name        = format("%s-public-a", var.environment)
    Environment = var.environment
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name        = format("%s-public-c", var.environment)
    Environment = var.environment
  }
}

##############################
# Private Subnets (A / C)
##############################

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = false

  tags = {
    Name        = format("%s-private-a", var.environment)
    Environment = var.environment
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.3.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = false

  tags = {
    Name        = format("%s-private-c", var.environment)
    Environment = var.environment
  }
}

##############################
# Public Route Table
##############################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = format("%s-public-rt", var.environment)
    Environment = var.environment
  }
}

##############################
# Route Table Associations
##############################

resource "aws_route_table_association" "public_a_association" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_c_association" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public_rt.id
}