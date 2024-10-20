# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"   # arguments
}

# resource block aws-vpc
resource "aws_vpc" "vpc-tf" {
  cidr_block       = "10.0.0.0/16"
 enable_dns_hostnames = "true"

  tags = {
    Name = "vpc-tf"
  }
}