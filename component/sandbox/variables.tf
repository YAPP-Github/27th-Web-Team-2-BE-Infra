variable "vpc_id" {
  description = "VPC ID for sandbox environment"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for ECS EC2 instances"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for ECS EC2"
  type        = string
  default     = "t2.micro"
}