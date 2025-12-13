variable "environment" { type = string }

variable "enable" {
  description = "sandbox 환경 리소스 생성 여부 제어용"
  type        = bool
  default     = true
}