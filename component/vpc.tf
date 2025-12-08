##############################
# VPC
##############################
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = format("%s-%s-vpc", var.team, var.environment)
    Environment = var.environment
    Team        = var.team
  }
}

##############################
# Internet Gateway
##############################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = format("%s-%s-igw", var.team, var.environment)
    Environment = var.environment
    Team        = var.team
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
    Name        = format("%s-%s-public-a", var.team, var.environment)
    Environment = var.environment
    Team        = var.team
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name        = format("%s-%s-public-c", var.team, var.environment)
    Environment = var.environment
    Team        = var.team
  }
}

##############################
# Private Subnets (A / C)
##############################

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = false

  tags = {
    Name        = format("%s-%s-private-a", var.team, var.environment)
    Environment = var.environment
    Team        = var.team
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = false

  tags = {
    Name        = format("%s-%s-private-c", var.team, var.environment)
    Environment = var.environment
    Team        = var.team
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
    Name        = format("%s-%s-public-rt", var.team, var.environment)
    Environment = var.environment
    Team        = var.team
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