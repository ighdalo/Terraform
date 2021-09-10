#========= creates VPC. Note: "enable_dns_hostnames = true" allows for dns resolution in the vpc
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy  = "default"
  enable_dns_hostnames = true
tags = {
Name = "my_vpc"
}
}


#=========== creates private subnet. You can add availability_zone = us xxx , here you need to check the availabilty zones available in your region. e.g in us-east-1, we have us-east-1a, us-east-1b etc  ========================================
# ======= You can create multiple subnet and specify availability zone for each subnet =========

resource "aws_subnet" "private_subnet" {
  vpc_id     =  aws_vpc.my_vpc.id
  cidr_block = var.vpc_private_subnet
# availability_zone = us-east-1a === (optional)
# ======= You can create multiple subnet and specify availability zone for each subnet =========
  tags = {
    Name = "private_subnet"
  }
}

#===== creates public subnet===============================================

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.vpc_public_subnet
# availability_zone = us-east-1a === (optional)
# ======= You can create multiple subnet and specify availability zone for each subnet =========
  tags = {
    Name = "public_subnet"
  }
}

#======= Creates security group. For testing purpose we are allowing ssh from anywhere ======

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id


  ingress {
    description      = "in-coming ssh traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    description      = "out-going ssh traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "test_SG"
  }
}

# ============ Creates internet gateway =========================
resource "aws_internet_gateway" "test_gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "test_gw"
  }
}

# ============ Creates public route table and associate a route (0.0.0.0/0) to direct traffic anywhere. You do not need private route table
# =============because we are not routing our private network to the outside world==========
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_gw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

#============ Associate the public rout table to the public subnet ====================

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}


