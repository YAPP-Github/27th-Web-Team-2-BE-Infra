variable "environment" {
  type = string
}

variable "alb_arn" {
  type = string
}

variable "alb_dns_name" {
  type = string
}

variable "alb_zone_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "enable_lambda_api" {
  type        = bool
  description = "API Gateway HTTP API + Lambda 병행 테스트 경로 생성 여부"
  default     = false
}

variable "lambda_image_uri" {
  type        = string
  description = "Lambda container image URI"
}

variable "lambda_memory_size" {
  type        = number
  description = "Lambda memory size in MB"
  default     = 1024
}

variable "lambda_timeout" {
  type        = number
  description = "Lambda timeout in seconds"
  default     = 30
}

variable "lambda_architectures" {
  type        = list(string)
  description = "Lambda instruction set architecture"
  default     = ["x86_64"]
}

variable "lambda_container_port" {
  type        = number
  description = "Port exposed by the Lambda web application"
  default     = 8080
}
