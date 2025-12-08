variable "environment" {
  description = "Deployment environment (sandbox || prod)"
  type        = string
  default     = "sandbox"

  validation {
    condition     = var.environment == "sandbox" || var.environment == "prod"
    error_message = "environment must be either 'sandbox' or 'prod'."
  }
}

variable "enable_sandbox" {
  description = "개발 환경 비용 절감을 위한 Resource 활성화 여부 (Production은 항상 true)"
  type        = bool
  default     = true
}


# region Discord Bot 관련 변수
variable "discord_public_key" {
  description = "Discord Bot Public Key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "github_token" {
  description = "GitHub Personal Access Token for triggering workflows"
  type        = string
  sensitive   = true
  default     = ""
}
