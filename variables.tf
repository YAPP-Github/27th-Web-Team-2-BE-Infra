variable "environment" {
  description = "Deployment environment (sandbox || prod)"
  type        = string
  default     = "sandbox"

  validation {
    condition     = var.environment == "sandbox" || var.environment == "prod"
    error_message = "environment must be either 'sandbox' or 'prod'."
  }
}

variable "aws_profile" {
  description = "AWS CLI Profile Name"
  type        = string
}

variable "aws_region" {
  type    = string
  default = "ap-northeast-2"
}

variable "enable_sandbox" {
  description = "개발 환경 비용 절감용 설정 (Production 환경에서는 무시됨)"
  type        = bool
  default     = true
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for ECS EC2"
}

variable "ssh_ingress_cidrs" {
  type        = list(string)
  description = "CIDRs allowed for SSH"
}

variable "app_ingress_cidrs" {
  type        = list(string)
  description = "CIDRs allowed for app port"
}

variable "container_image_tag" {
  type        = string
  description = "ECR image tag to deploy"
}

variable "container_port" {
  type        = number
  description = "Container port"
  default     = 8080
}

variable "enable_lambda_api" {
  type        = bool
  description = "API Gateway HTTP API + Lambda 병행 테스트 경로 생성 여부"
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

  validation {
    condition     = length(var.lambda_architectures) == 1 && contains(["x86_64", "arm64"], var.lambda_architectures[0])
    error_message = "lambda_architectures must contain exactly one value: x86_64 or arm64."
  }
}

# # region Discord Bot 관련 변수
# variable "discord_public_key" {
#   description = "Discord Bot Public Key"
#   type        = string
#   sensitive   = true
#   default     = ""
# }
#
# variable "github_token" {
#   description = "GitHub Personal Access Token for triggering workflows"
#   type        = string
#   sensitive   = true
#   default     = ""
# }
