variable "environment" { type = string }

variable "enable" {
  description = "sandbox 환경 리소스 생성 여부 제어용"
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "EC2 instance type for ECS EC2"
  type        = string
  default     = "t3.micro"
}

variable "ssh_ingress_cidrs" {
  type = list(string)
}

variable "app_ingress_cidrs" {
  type = list(string)
}

variable "container_image_tag" {
  type = string
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "enable_lambda_api" {
  type        = bool
  description = "API Gateway HTTP API + Lambda 병행 테스트 경로 생성 여부"
  default     = false
}

variable "route_primary_api_to_lambda" {
  type        = bool
  description = "기존 api.* 도메인을 ALB 대신 Lambda HTTP API로 라우팅할지 여부"
  default     = false
}

variable "lambda_image_tag" {
  type        = string
  description = "Lambda container image tag"
  default     = "latest"
}

variable "lambda_memory_size" {
  type        = number
  description = "Lambda memory size in MB"
  default     = 2048
}

variable "lambda_timeout" {
  type        = number
  description = "Lambda timeout in seconds"
  default     = 90
}

variable "lambda_alias_name" {
  type        = string
  description = "Lambda alias name used by API Gateway"
  default     = "live"
}

variable "lambda_provisioned_concurrency" {
  type        = number
  description = "Provisioned concurrency count for the Lambda API alias"
  default     = 0
}

variable "lambda_keep_warm_enabled" {
  type        = bool
  description = "Whether to keep the Lambda API alias warm with EventBridge"
  default     = true
}

variable "lambda_keep_warm_schedule_expression" {
  type        = string
  description = "EventBridge schedule expression for Lambda API keep-warm invokes"
  default     = "rate(5 minutes)"
}

variable "lambda_architectures" {
  type        = list(string)
  description = "Lambda instruction set architecture"
  default     = ["x86_64"]
}
