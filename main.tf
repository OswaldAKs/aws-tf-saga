# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"   # arguments
}

# resource block 
# vpc
resource "aws_vpc" "vpc-tf" {
  cidr_block       = "10.0.0.0/16"
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
  vpc_id     = aws_vpc.vpc-tf.id   # attach it to the vpc
  cidr_block = "10.0.1.0/24"    # cidr range

  tags = {
    Name = "pub-subnet-tf"
  }
}

# route table

resource "aws_route_table" "pub-rt-tf" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"       # change to 0.0.0.0 for internet access
    gateway_id = aws_internet_gateway.ig-tf.id   # attach it to the internet gateway
  }

  tags = {
    name = "pub-rt-tf"
  }

}

