resource "docker_registry_image" "gatus" {
  name          = docker_image.gatus.name
}

resource "docker_image" "gatus" {
  name = "registry.hub.docker.com/danhill2802/gatus:0.0.0-${var.env}"
  build {
    context = "${path.module}/docker"
  }
}
