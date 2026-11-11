terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "npipe:////./pipe/dockerDesktopLinuxEngine"
}

resource "docker_network" "stack" {
  name = var.network_name
}

resource "docker_volume" "pgdata" {
  name = "tf-stack-pgdata"

  lifecycle {
    prevent_destroy = true
  }
}

resource "docker_image" "postgres" {
  name         = "postgres:16-alpine"
  keep_locally = true
}

resource "docker_image" "nginx" {
  name         = "nginx:1.27-alpine"
  keep_locally = true
}

resource "docker_container" "db" {
  name  = "tf-stack-db"
  image = docker_image.postgres.image_id
  wait  = true

  env = [
    "POSTGRES_DB=${var.db_name}",
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
  ]

  ports {
    internal = 5432
    external = var.postgres_port
  }

  volumes {
    volume_name    = docker_volume.pgdata.name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name    = docker_network.stack.name
    aliases = ["db"]
  }

  healthcheck {
    test     = ["CMD-SHELL", "pg_isready -U ${var.db_user} -d ${var.db_name}"]
    interval = "5s"
    timeout  = "3s"
    retries  = 5
  }
}

resource "docker_container" "web" {
  name       = "tf-stack-web"
  image      = docker_image.nginx.image_id
  depends_on = [docker_container.db]

  ports {
    internal = 80
    external = var.nginx_port
  }

  networks_advanced {
    name    = docker_network.stack.name
    aliases = ["web"]
  }
}
