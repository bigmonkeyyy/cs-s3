resource "aws_subnet" "frontend-az1" {
  vpc_id                  = var.frontned_vpc_id
  cidr_block              = var.frontend_sub1_cidr
  availability_zone       = var.aws_az1
  map_public_ip_on_launch = true

  tags = {
    Client = var.client
  }
}

resource "aws_subnet" "frontend-az2" {
  vpc_id                  = var.frontned_vpc_id
  cidr_block              = var.frontend_sub2_cidr
  availability_zone       = var.aws_az2
  map_public_ip_on_launch = true

  tags = {
    Client = var.client
  }
}

resource "aws_subnet" "priv-app-az1" {
  vpc_id                  = var.backend_vpc_id
  cidr_block              = var.backend_sub1_cidr
  availability_zone       = var.aws_az1
  map_public_ip_on_launch = true

  tags = {
    Client = var.client
  }
}

resource "aws_subnet" "priv-app-az2" {
  vpc_id                  = var.backend_vpc_id
  cidr_block              = var.backend_sub2_cidr
  availability_zone       = var.aws_az2
  map_public_ip_on_launch = true
  
  tags = {
    Client = var.client
  } 
}

resource "aws_subnet" "priv-db-az1" {
  vpc_id                  = var.backend_vpc_id
  cidr_block              = var.backend_sub3_cidr
  availability_zone       = var.aws_az1
  map_public_ip_on_launch = true

  tags = {
    Client = var.client
  } 
}

resource "aws_subnet" "priv-db-az2" {
  vpc_id                  = var.backend_vpc_id
  cidr_block              = var.backend_sub4_cidr
  availability_zone       = var.aws_az2
  map_public_ip_on_launch = true

  tags = {
    Client = var.client
  } 
}