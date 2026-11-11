variable "env_name" {
  type = string
}

variable "nginx_port" {
  type = number
}

variable "postgres_port" {
  type = number
}

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_user" {
  type    = string
  default = "appuser"
}

variable "db_password" {
  type      = string
  sensitive = true
}
