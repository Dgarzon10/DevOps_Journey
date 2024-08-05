terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"
    }
  }
}

provider "docker" {
  # Configuration options
}

# Define the Docker image for Nginx
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

# Define the Docker container for Nginx
resource "docker_container" "nginx_container" {
  image = docker_image.nginx.latest
  name  = "webserver"

  ports {
    internal = 80
    external = 8050
  }
}

# Define the Docker image for PostgreSQL
resource "docker_image" "postgres" {
  name         = "postgres:latest"
  keep_locally = false
}

# Define the Docker container for PostgreSQL
resource "docker_container" "postgres_container" {
  image = docker_image.postgres.latest
  name  = "postgres"

  env = [
    "POSTGRES_USER=myuser",
    "POSTGRES_PASSWORD=mysecretpassword",
    "POSTGRES_DB=mydatabase"
  ]

  ports {
    internal = 5432
    external = 8000
  }

  volumes {
    host_path      = "/path/on/host"
    container_path = "/var/lib/postgresql/data"
  }
}
