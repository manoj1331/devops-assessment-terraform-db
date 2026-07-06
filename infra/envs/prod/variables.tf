variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project" {
  type    = string
  default = "hotel-booking"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "container_image" {
  type    = string
  default = "nginx:latest"
}

variable "container_port" {
  type    = number
  default = 80
}

variable "task_cpu" {
  type = string
}

variable "task_memory" {
  type = string
}

variable "desired_count" {
  type = number
}

variable "db_engine" {
  type    = string
  default = "postgres"
}

variable "db_instance_class" {
  type = string
}

variable "db_allocated_storage" {
  type    = number
  default = 100
}

variable "db_name" {
  type    = string
  default = "hotel_booking"
}

variable "db_username" {
  type    = string
  default = "app_user"
}

variable "db_port" {
  type    = number
  default = 5432
}

variable "backup_retention_period" {
  type = number
}

variable "deletion_protection" {
  type = bool
}

variable "multi_az" {
  type    = bool
  default = true
}
