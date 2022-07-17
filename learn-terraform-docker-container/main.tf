terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.13.0"
    }
  }
}

provider "docker" {
  host    = "npipe:////.//pipe//docker_engine"
}

resource "docker_image" "sherlock" {
  name         = "mysherlock-image"
  keep_locally = false
}

resource "docker_container" "sherlock" {
  image = docker_image.sherlock.latest
  name  = "tutorial"
  ports {
    internal = 80
    external = 8000
  }
}