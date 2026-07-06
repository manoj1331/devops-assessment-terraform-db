variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "rds_security_group_id" {
  type = string
}

variable "engine" {
  type    = string
  default = "postgres"
}

variable "engine_version" {
  type    = string
  default = "15.4"
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "db_name" {
  type    = string
  default = "app"
}

variable "db_username" {
  description = "Master username for the database. Provide via TF_VAR_db_username or a secrets manager, never commit real values."
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master password for the database. Provide via TF_VAR_db_password or a secrets manager, never commit real values."
  type        = string
  sensitive   = true
}

variable "db_port" {
  type    = number
  default = 5432
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups"
  type        = number
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection on the RDS instance"
  type        = bool
}

variable "multi_az" {
  type    = bool
  default = false
}
