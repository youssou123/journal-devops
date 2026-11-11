output "nginx_url" {
  value = "http://localhost:${var.nginx_port}"
}

output "psql_command" {
  value = "docker exec -it ${docker_container.db.name} psql -U ${var.db_user} -d ${var.db_name}"
}

output "network_name" {
  value = docker_network.this.name
}
