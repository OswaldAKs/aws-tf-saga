# Configure the AWS Provider
provider "aws" {
  region = "us-east-1" # arguments
}

# resource block 
# vpc
resource "aws_vpc" "vpc-tf" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"

  tags = {
    Name = "vpc-tf"
  }
}

#  internet gateway
resource "aws_internet_gateway" "ig-tf" {
  vpc_id = aws_vpc.vpc-tf.id

  tags = {
    Name = "ig-tf"
  }
}

# public subnet
resource "aws_subnet" "pub-subnet-tf" {
  vpc_id     = aws_vpc.vpc-tf.id # attach it to the vpc
  cidr_block = "10.0.1.0/24"     # cidr range

  tags = {
    Name = "pub-subnet-tf"
  }
}

# route table

resource "aws_route_table" "pub-rt-tf" {
  vpc_id = aws_vpc.vpc-tf.id    # mention the vpc here

  route {
    cidr_block = "0.0.0.0/0"                   # change to 0.0.0.0 for internet access
    gateway_id = aws_internet_gateway.ig-tf.id # attach it to the internet gateway
  }

  tags = {
    name = "pub-rt-tf"
  }

}

# route table association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.pub-subnet-tf.id
  route_table_id = aws_route_table.pub-rt-tf.id
}

# sec groups

resource "aws_security_group" "example_sg" {
  name        = "example_security_group"
  description = "Security group for example application"
  vpc_id      = aws_vpc.vpc-tf.id # mention the vpc 

  # Ingress 
  ingress {
    from_port   = 80 # 80 (HTTP) - allow on port 80 and similar for 443 
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # from any where you can able to access port:80
  }

  ingress {
    from_port   = 22 # Allow 22 (SSH)
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ssh from anywhere
  }

  # Egress 
  egress {
    from_port   = 0 # Allow all outbound traffic 
    to_port     = 0
    protocol    = "-1"          # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic to anywhere
  }
}