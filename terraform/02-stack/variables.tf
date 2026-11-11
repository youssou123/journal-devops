variable "network_name" {
  type    = string
  default = "tf-stack-net"
}

variable "nginx_port" {
  type    = number
  default = 8085
}

variable "postgres_port" {
  type    = number
  default = 5435
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
