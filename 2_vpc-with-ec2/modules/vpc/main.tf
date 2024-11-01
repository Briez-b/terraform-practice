# Create VPC and 4 subnets
resource "aws_vpc" "terr_vpc" {
  cidr_block = var.vpc-cidr

  tags = {
    Name = "TerrVPC"
  }
}

resource "aws_subnet" "pub_sub1" {
  vpc_id                  = aws_vpc.terr_vpc.id
  cidr_block              = var.pub-sub1-cidr
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "TerrVPC-pubsub1"
  }  
}

resource "aws_subnet" "pub_sub2" {
  vpc_id                  = aws_vpc.terr_vpc.id
  cidr_block              = var.pub-sub2-cidr
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "TerrVPC-pubsub2"
  }  
}

resource "aws_subnet" "prv_sub1" {
  vpc_id                  = aws_vpc.terr_vpc.id
  cidr_block              = var.prv-sub1-cidr
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "TerrVPC-prvsub1"
  }  
}

resource "aws_subnet" "prv_sub2" {
  vpc_id                  = aws_vpc.terr_vpc.id
  cidr_block              = var.prv-sub2-cidr
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "TerrVPC-prvsub2"
  }  
}

# Create internet and nat gateways and route tables
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.terr_vpc.id

  tags = {
    Name = "TerrVPC-igw"
  }  
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.pub_sub1.id
}

resource "aws_route_table" "prv_rt" {
  vpc_id = aws_vpc.terr_vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "TerrVPC-prv_rt"
  }  
}

resource "aws_route_table_association" "prvrta1" {
  subnet_id      = aws_subnet.prv_sub1.id
  route_table_id = aws_route_table.prv_rt.id
}

resource "aws_route_table_association" "prvrta2" {
  subnet_id      = aws_subnet.prv_sub2.id
  route_table_id = aws_route_table.prv_rt.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.terr_vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "TerrVPC-rt"
  }  
}

resource "aws_route_table_association" "pubrta1" {
  subnet_id      = aws_subnet.pub_sub1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "pubrta2" {
  subnet_id      = aws_subnet.pub_sub2.id
  route_table_id = aws_route_table.rt.id
}