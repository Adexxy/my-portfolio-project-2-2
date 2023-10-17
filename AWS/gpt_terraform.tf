# Configure AWS provider
provider "aws" {
  region = "us-west-2" # Change to your desired AWS region
}

# Define a VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16" # Replace with your desired CIDR block
}

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

# Define an EKS cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "example-eks-cluster"
  role_arn = "arn:aws:iam::123456789012:role/eks-cluster-role" # Replace with your IAM role ARN for EKS

  vpc_config {
    subnet_ids         = [aws_subnet.example_subnet1.id, aws_subnet.example_subnet2.id] # Replace with your subnet IDs
    security_group_ids = ["sg-12345678"] # Replace with your security group IDs
  }
}

# Define EKS node group
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "example-node-group"
  node_role_arn   = "arn:aws:iam::123456789012:role/eks-node-role" # Replace with your IAM role ARN for EKS nodes

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 3
  }

  launch_template {
    version = "$Latest"

    # Specify the Amazon Linux 2 AMI with Docker installed
    launch_template_specification {
      launch_template_id = "lt-12345678" # Replace with your launch template ID
      version            = "1"          # Replace with the desired version of the launch template
    }
  }

  remote_access {
    ec2_ssh_key = "your_ssh_key_name" # Replace with your SSH key name
  }

  vpc_config {
    subnet_ids = [aws_subnet.example_subnet1.id, aws_subnet.example_subnet2.id] # Replace with your subnet IDs
  }
}

# Define an EC2 instance for Jenkins
resource "aws_instance" "jenkins_server" {
  ami           = "ami-12345678" # Replace with the Jenkins AMI ID
  instance_type = "t2.micro"     # Replace with the desired instance type

  # Configure the instance in a specific subnet and security group
  subnet_id              = aws_subnet.example_subnet1.id # Use one of the subnets
  vpc_security_group_ids = ["sg-12345678"]              # Replace with your desired security group IDs

  # Example user data to install Docker on startup (replace with your desired configuration)
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              EOF
}

# Define an S3 bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket-name" # Replace with your desired bucket name
  acl    = "private"
}
