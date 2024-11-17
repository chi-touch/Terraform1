## main.tf
#
## Specify the Docker provider
#provider "docker" {}
#
## Define Docker image resource
#resource "docker_image" "app_image" {
#  name = "chichia/devip:latest"
#}
#
## Define Docker container resource
#resource "docker_container" "app_container" {
#  name  = "app_container"
#  image = docker_image.app_image.name
#  ports {
#    internal = 8082
#    external = 8082
#  }
#  env = [
#    "SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/terraf",
#    "SPRING_DATASOURCE_USERNAME=postgres",
#    "SPRING_DATASOURCE_PASSWORD=password",
#    "SPRING_PROFILES_ACTIVE=prod"
#  ]
#}


# main.tf

# Specify the required provider source
#terraform {
#  required_providers {
#    docker = {
#      source  = "kreuzwerker/docker"
#      version = "~> 2.0"  # Adjust version as needed
#    }
#  }
#}
#
## Initialize Docker provider
#provider "docker" {}
#
## Define Docker image resource
#resource "docker_image" "app_image" {
#  name = "chichia/terraf:latest"
#}
#
## Define Docker container resource
#resource "docker_container" "app_container" {
#  name  = "app_container"
#  image = docker_image.app_image.name
#  ports {
#    internal = 8082
#    external = 8082
#  }
#  env = [
#    "SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/terraf",
#    "SPRING_DATASOURCE_USERNAME=postgres",
#    "SPRING_DATASOURCE_PASSWORD=password",
#    "SPRING_PROFILES_ACTIVE=prod"
#  ]
#}

#  Specify the required provider source
#terraform {
#    required_providers {
#      docker = {
#        source  = "kreuzwerker/docker"
#        version = "~> 2.0"  # Adjust version as needed
#      }
#    }
#}

## Configure the AWS provider
#provider "aws" {
#  region     = var.aws_region
#  access_key = var.aws_access_key
#  secret_key = var.aws_secret_key
#}
#
#
## Define a security group for the EC2 instance
#resource "aws_security_group" "ec2_sg" {
#  name_prefix = "ec2-sg"
#
#  # Allow inbound access to port 8082 for the Docker container
#  ingress {
#    from_port   = 8082
#    to_port     = 8082
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]  # Open to all IPs; restrict this in production
#  }
#
#  # Allow SSH access for debugging (optional)
#  ingress {
#    from_port   = 22
#    to_port     = 22
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}
#
## Define an EC2 instance with a user data script to install Docker
#resource "aws_instance" "ec2_instance" {
#  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI; replace as needed
#  instance_type = "t2.micro"
#  key_name      = "your-key-pair"          # Replace with your actual key pair name
#
#  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
#
#  # Use the user data script to install Docker and run your container
#  user_data = <<-EOF
#              #!/bin/bash
#              # Install Docker
#              yum update -y
#              amazon-linux-extras install docker -y
#              service docker start
#              usermod -a -G docker ec2-user
#
#              # Run the Docker container
#              docker run -d -p 8082:8082 -e SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/terraf \
#                -e SPRING_DATASOURCE_USERNAME=postgres \
#                -e SPRING_DATASOURCE_PASSWORD=password \
#                -e SPRING_PROFILES_ACTIVE=prod \
#                chichia/terraf:latest
#              EOF
#
#  tags = {
#    Name = "DockerAppEC2"
#  }
#}
#
## Output the public IP of the instance for connection
#output "ec2_public_ip" {
#  value = aws_instance.ec2_instance.public_ip
#  description = "Public IP of the EC2 instance"
#}
#


# Configure the AWS provider
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Fetch the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["08103722570"]  # Canonical AMIs

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"]
  }
}

# Define a security group
resource "aws_security_group" "app_sg" {
  name_prefix = "app-sg"

  # Allow inbound traffic to the Docker container (port 8082)
  ingress {
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH access for debugging
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#resource "aws_instance" "app_instance" {
#  ami               = "ami-0c55b159cbfafe1f0"
#  instance_type     = "t2.micro"
#  key_name          = var.key_name
#  vpc_security_group_ids = [aws_security_group.app_sg.id]  # Attach the security group here
#
#  tags = {
#    Name = "AppInstance"
#  }
#}


# Define an EC2 instance with a user data script
resource "aws_instance" "app_instance" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = "t2.micro"
  key_name          = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  # Use the user data script to install Docker and run the app
user_data = <<-EOF
              #!/bin/bash
              # Update and install Docker
              yum update -y
              amazon-linux-extras enable docker
              yum install -y docker

              # Start Docker service
              service docker start
              usermod -a -G docker ec2-user

              # Run the application container
              docker network create app-network
              docker run -d --name=my-database --network=app-network \
                -e POSTGRES_PASSWORD=password postgres
              docker run -d --name=my-app --network=app-network \
                -e DATABASE_URL=jdbc:postgresql://postgres:5432/mydb \
                chichia/terraf:latest
              EOF

  tags = {
    Name = "DockerAppInstance"
  }


# Output the public IP of the EC2 instance
output "instance_public_ip" {
  value       = aws_instance.app_instance.public_ip
  description = "Public IP of the EC2 instance"
}
