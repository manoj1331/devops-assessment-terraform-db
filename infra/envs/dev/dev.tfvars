aws_region  = "us-east-1"
project     = "hotel-booking"
environment = "dev"

vpc_cidr             = "10.0.0.0/16"
azs                  = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]

container_image = "nginx:latest"
container_port  = 80
task_cpu        = "256"
task_memory     = "512"
desired_count   = 1

db_instance_class       = "db.t3.micro"
db_allocated_storage    = 20
backup_retention_period = 1
deletion_protection     = false
multi_az                = false
