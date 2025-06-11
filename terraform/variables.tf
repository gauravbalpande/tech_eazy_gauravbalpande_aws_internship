variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "stage" {
  description = "Deployment stage: dev or prod"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use"
  default     = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 (example)
}

variable "s3_bucket_name" {
  description = "Private S3 bucket name"
  type        = string
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}