aws_region  = "us-east-1"
project     = "hotel-booking"
environment = "prod"

vpc_cidr             = "10.1.0.0/16"
azs                  = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.1.0.0/24", "10.1.1.0/24"]
private_subnet_cidrs = ["10.1.10.0/24", "10.1.11.0/24"]

container_image = "nginx:latest"
container_port  = 80
task_cpu        = "512"
task_memory     = "1024"
desired_count   = 2

db_instance_class       = "db.t3.medium"
db_allocated_storage    = 100
backup_retention_period = 7
deletion_protection     = true
multi_az                = true
