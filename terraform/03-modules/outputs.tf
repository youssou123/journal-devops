output "staging_nginx_url" {
  value = module.staging.nginx_url
}

output "staging_psql_command" {
  value = module.staging.psql_command
}

output "production_nginx_url" {
  value = module.production.nginx_url
}

output "production_psql_command" {
  value = module.production.psql_command
}
