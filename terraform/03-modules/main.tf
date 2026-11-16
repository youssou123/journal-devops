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

module "staging" {
  source        = "./modules/stack"
  env_name      = "staging"
  nginx_port    = 8085
  postgres_port = 5435
  db_password   = var.db_password
}

module "production" {
  source        = "./modules/stack"
  env_name      = "production"
  nginx_port    = 8086
  postgres_port = 5436
  db_password   = var.db_password_production
}
