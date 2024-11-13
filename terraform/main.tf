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
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"  # Adjust version as needed
    }
  }
}

# Initialize Docker provider
provider "docker" {}

# Define Docker image resource
resource "docker_image" "app_image" {
  name = "chichia/terraf:latest"
}

# Define Docker container resource
resource "docker_container" "app_container" {
  name  = "app_container"
  image = docker_image.app_image.name
  ports {
    internal = 8082
    external = 8082
  }
  env = [
    "SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/terraf",
    "SPRING_DATASOURCE_USERNAME=postgres",
    "SPRING_DATASOURCE_PASSWORD=password",
    "SPRING_PROFILES_ACTIVE=prod"
  ]
}
