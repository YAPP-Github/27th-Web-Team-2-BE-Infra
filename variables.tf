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
