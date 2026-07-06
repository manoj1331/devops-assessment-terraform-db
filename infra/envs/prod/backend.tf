# Configure remote state storage before running `terraform init`.
# Replace the placeholder bucket/table names with your own, or remove
# this block entirely to use local state for evaluation purposes.
terraform {
  backend "s3" {
    bucket         = "REPLACE_WITH_YOUR_TF_STATE_BUCKET"
    key            = "devops-assessment/prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "REPLACE_WITH_YOUR_TF_LOCK_TABLE"
    encrypt        = true
  }
}
