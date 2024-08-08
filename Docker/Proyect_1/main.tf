terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}
// Hay que crear la imagen manualmente -> docker build -t myapp:latest . NO funciona 
resource "docker_network" "myapp" {
  name = "myapp"
}


resource "docker_image" "myapp" {
  name = "myapp:latest"
}

resource "docker_container" "myapp" {
  name  = "myapp"
  image = docker_image.myapp.image_id
  ports {
    internal = 3000
    external = 3000
  }
  networks_advanced {
    name = docker_network.myapp.name
  }
  depends_on = [docker_image.myapp]
}

resource "docker_image" "monguito" {
  name = "mongo:latest"
}

resource "docker_container" "monguito" {
  name  = "monguito"
  image = docker_image.monguito.image_id
  ports {
    internal = 27017
    external = 27017
  }
  env = [
    "MONGO_INITDB_ROOT_USERNAME=dani",
    "MONGO_INITDB_ROOT_PASSWORD=password",
    "MONGO_INITDB_DATABASE=mydatabase"
  ]
  # volumes {
  #   host_path      = "/path/on/host"
  #   container_path = "/data/db"
  # }
  networks_advanced {
    name = docker_network.myapp.name
  }
  depends_on = [docker_image.monguito]
}

