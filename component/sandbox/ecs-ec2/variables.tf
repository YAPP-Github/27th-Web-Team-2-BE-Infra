variable "environment" {
  type        = string
  description = "Environment name (e.g., sandbox)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs for ECS EC2 instances"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for ECS EC2"
  default     = "t2.micro"
}

variable "ecs_desired_capacity" {
  type        = number
  description = "ASG desired capacity for ECS instances"
  default     = 1
}

variable "ecs_min_size" {
  type        = number
  description = "ASG min size"
  default     = 1
}

variable "ecs_max_size" {
  type        = number
  description = "ASG max size"
  default     = 1
}

variable "ssh_ingress_cidrs" {
  type        = list(string)
  description = "CIDRs allowed for SSH (22). Empty = no SSH ingress."
  default     = []
}

variable "app_ingress_cidrs" {
  type        = list(string)
  description = "CIDRs allowed for app port. For sandbox you may set 0.0.0.0/0 temporarily."
  default     = []
}

variable "container_image" {
  type        = string
  description = "Container image for ECS Task (e.g., ECR image URI)"
}

variable "container_port" {
  type        = number
  description = "Container port exposed by the app"
  default     = 8080
}

variable "cpu" {
  type        = number
  description = "Task CPU units (1024 = 1 vCPU)"
  default     = 256
}

variable "memory" {
  type        = number
  description = "Task memory (MiB)"
  default     = 512
}

variable "log_retention_in_days" {
  type        = number
  description = "CloudWatch log group retention"
  default     = 7
}