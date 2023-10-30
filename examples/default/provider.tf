terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Name = "${var.env}-gatus-default"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
  registry_auth {
    address = "registry.hub.docker.com"
  }
}
