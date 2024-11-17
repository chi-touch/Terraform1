#variable "aws_access_key" {}
#variable "aws_secret_key" {}
variable "AWS_DEFAULT_REGION" {
  default = "us-east-1"
}


# variables.tf

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "POSTGRES_PASSWORD" {
  description = "Postgres password"
  type        = string
  sensitive   = true
}
