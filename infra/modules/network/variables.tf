variable "project" {
  description = "Project name used for tagging and naming resources"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod, etc.)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "Availability zones to use"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "container_port" {
  description = "Port the ECS application container listens on"
  type        = number
  default     = 80
}

variable "db_port" {
  description = "Port the RDS database listens on"
  type        = number
  default     = 5432
}
