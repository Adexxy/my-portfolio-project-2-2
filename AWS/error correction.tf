# Configure AWS provider
provider "aws" {
  region = "us-west-2" # Change to your desired AWS region
}

# Define a VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16" # Replace with your desired CIDR block
}

# Define an EKS cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "example-eks-cluster"
  role_arn = "arn:aws:iam::123456789012:role/eks-cluster-role" # Replace with your IAM role ARN for EKS

  vpc_config {
    subnet_ids          = [aws_subnet.example_subnet1.id, aws_subnet.example_subnet2.id] # Replace with your subnet IDs
    security_group_ids  = ["sg-12345678"] # Replace with your security group IDs
  }
}

# Define EKS node group
resource "aws_eks_node_group" "eks_node_group" {
  # ... (existing configuration)

  vpc_config {
    subnet_ids = [aws_subnet.example_subnet1.id, aws_subnet.example_subnet2.id] # Replace with your subnet IDs
  }

  # ... (existing configuration)
}

# ... (existing configuration)

# Define subnets
resource "aws_subnet" "example_subnet1" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.1.0/24" # Replace with your desired CIDR block
  availability_zone       = "us-west-2a" # Replace with your desired AZ
}

resource "aws_subnet" "example_subnet2" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.2.0/24" # Replace with your desired CIDR block
  availability_zone       = "us-west-2b" # Replace with your desired AZ
}

# ... (existing configuration)
